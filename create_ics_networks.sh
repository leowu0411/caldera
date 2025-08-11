#!/usr/bin/env bash
set -euo pipefail

create_or_verify() {
  local name="$1"
  local subnet="$2"
  local gateway="${3:-}"
  local bridge_opt="${4:-}"   # ex: com.docker.network.bridge.name=br_xxx

  if docker network inspect "$name" >/dev/null 2>&1; then
    current_subnet="$(docker network inspect "$name" -f '{{ (index .IPAM.Config 0).Subnet }}')"
    if [[ "$current_subnet" != "$subnet" ]]; then
      echo " 網路 '$name' 已存在，但子網是 $current_subnet（期待 $subnet）。"
      echo "    如需調整，請先執行：docker network rm $name  再重跑本腳本。"
    else
      echo "網路 '$name' 已存在且子網一致（$subnet）。"
    fi
    return
  fi

  echo "建立網路 '$name'（$subnet）..."
  args=(network create --driver bridge --subnet "$subnet")
  [[ -n "$gateway" ]]   && args+=(--gateway "$gateway")
  [[ -n "$bridge_opt" ]] && args+=(--opt "$bridge_opt")
  args+=("$name")
  docker "${args[@]}"
  echo "建立完成：$name"
}

# —— 依你現有設定建立三條網路 ——
# Caldera overlay/bridge：172.18.0.0/16
create_or_verify "caldera-net" "172.18.0.0/16" "" "com.docker.network.bridge.name=br_caldera"

# ICSSIM workcell (wnet)：192.168.0.0/24，固定 gateway 192.168.0.1，橋接名 br_icsnet
create_or_verify "icsnet" "192.168.0.0/24" "192.168.0.1" "com.docker.network.bridge.name=br_icsnet"

# ICSSIM phys (fnet)：192.168.1.0/24，固定 gateway 192.168.1.1，橋接名 br_phynet
create_or_verify "phynet" "192.168.1.0/24" "192.168.1.1" "com.docker.network.bridge.name=br_phynet"

echo "全部處理完成。"

