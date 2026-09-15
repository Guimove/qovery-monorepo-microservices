type Fields = Record<string, unknown>;

export function createLogger(service: string) {
  const write = (level: "info" | "error", message: string, fields: Fields = {}) => {
    const line = { timestamp: new Date().toISOString(), level, service, message, ...fields };
    const output = JSON.stringify(line);
    if (level === "error") console.error(output);
    else console.log(output);
  };

  return {
    info: (message: string, fields?: Fields) => write("info", message, fields),
    error: (message: string, fields?: Fields) => write("error", message, fields)
  };
}
