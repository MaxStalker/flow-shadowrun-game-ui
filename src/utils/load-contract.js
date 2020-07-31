
export default async (url, match) => {
  const codeFile = await fetch(url);
  const rawCode = await codeFile.text();
  if (!match) {
    return rawCode;
  }

  const { query } = match;
  return rawCode.replace(query, (item) => {
    return match[item];
  });
};
