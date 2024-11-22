#!/usr/bin/env -S deno run --allow-all

import $ from "https://deno.land/x/dax/mod.ts";
import { serve } from "./serve.ts";

const window_title = async () => {
  let active_window = await $`hyprctl activewindow -j`.json();
  if (active_window.title) {
    console.log(JSON.stringify(active_window.title.substring(0, 35)));
  }
};

await serve(window_title);

Deno.test("url test", async () => {
  await window_title();
});
