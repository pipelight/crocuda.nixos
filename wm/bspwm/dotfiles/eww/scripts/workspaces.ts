#!/usr/bin/env -S deno run --allow-all

import $ from "https://deno.land/x/dax/mod.ts";

const active = (name: string) => {
  const classes = "workspace active";
  const box = `(box	:class "${classes}" :orientation "h" ${name})`;
  return box;
};
const focused = (name: string) => {
  const classes = "workspace focused";
  const box = `(box	:class "${classes}" :orientation "h" ${name})`;
  return box;
};
const inactive = (name: string) => {
  const box = `(box	:class "workspace" :orientation "h" ${name})`;
  return box;
};

/**
Display workspaces in yuck
*/
const display_widget = async () => {
  const widget =
    `(box :class "workspaces" :orientation "h" :spacing 5 :space-evenly "false" ${await display_workspaces()})`;
  return widget;
};

const display_workspaces = async () => {
  let workspaces = "";
  const nodes = await $`bspc query -D --names`.lines();
  for (const node of nodes) {
    // Compute desktop states
    const is_focused = node == await $`bspc query -D --names -d focused`.text();

    let is_active = false;
    const cmd = $`bspc query -D --names -d ${node}.occupied`.text();
    try {
      is_active = await cmd;
    } catch {
    }

    // Set desktop css accordingly
    if (is_focused) {
      workspaces += focused(node);
    } else if (is_active) {
      workspaces += active(node);
    } else {
      workspaces += inactive(node);
    }
  }
  return workspaces;
};

const main = async () => {
  console.log(await display_widget());
  // console.log(await inactive("1"));
};

main();
