export const serve = async (fn: any) => {
  const hypr_instance = Deno.env.get("HYPRLAND_INSTANCE_SIGNATURE");

  let connection = await Deno.connect({
    transport: "unix",
    path: `/tmp/hypr/${hypr_instance}/.socket2.sock`,
  });

  for await (const chunk of Deno.iter(connection)) {
    // Read socket event
    let str = new TextDecoder().decode(chunk);
    // Exec provided function
    await fn();
  }
};
