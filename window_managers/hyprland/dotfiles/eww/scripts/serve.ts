export const serve = async (fn: any) => {
  const hypr_instance = Deno.env.get("HYPRLAND_INSTANCE_SIGNATURE");

  const runtime_dir = Deno.env.get("XDG_RUNTIME_DIR");

  let connection = await Deno.connect({
    transport: "unix",
    path: `${runtime_dir}/hypr/${hypr_instance}/.socket2.sock`,
  });

  for await (const chunk of connection.readable.values()) {
    // Read socket event
    let str = new TextDecoder().decode(chunk);
    // Exec provided function
    await fn();
  }
};
