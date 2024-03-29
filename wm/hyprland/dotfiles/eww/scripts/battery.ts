#!/usr/bin/env -S deno run --allow-all

import $ from "https://deno.land/x/dax/mod.ts";
import { serve } from "./serve.ts";

const battery_level = async () => {
  let data = await Deno.readFile("/sys/class/power_supply/BAT0/capacity");
  const decoder = new TextDecoder("utf-8");
  let level = decoder.decode(data);
  console.log(level);
};

await serve(battery_level);
