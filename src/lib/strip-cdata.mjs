export default function (code = "") {
  return code.replace("<![CDATA[", "").replace("]]>", "").trim();
}
