#!/usr/bin/env -S deno run --allow-all

import $ from "https://deno.land/x/dax/mod.ts";
import { serve } from "./serve.ts";

const active = (name: string): string => {
  const classes = "workspace active";
  const box = `(box	:class "${classes}" :orientation "h" ${name})`;
  return box;
};
const focused = (name: string): string => {
  const classes = "workspace focused";
  const box = `(box	:class "${classes}" :orientation "h" ${name})`;
  return box;
};
const inactive = (name: string): string => {
  const box = `(box	:class "workspace" :orientation "h" ${name})`;
  return box;
};

const make_boxes = async (): Promise<string> => {
  let boxes = "";
  let active_workpsace = await $`hyprctl activeworkspace -j`.json();
  let workspaces = await $`hyprctl workspaces -j`.json();
  workspaces.map((e) => {
    if (e.id == active_workpsace.id) {
      boxes += focused(e.name);
    } else if (e.windows > 0) {
      boxes += active(e.name);
    } else {
      boxes += inactive(e.name);
    }
  });
  return boxes;
};

const make_widget = async (): Promise<string> => {
  console.log(
    `(box :class "workspaces bar" :orientation "h" :spacing 8 :space-evenly false :valign "baseline" :halign "start" ${await make_boxes()})`,
  );
};

await serve(make_widget);
