import jsdom from "jsdom";
import jQuery from "jquery";

const window = new jsdom.JSDOM().window;
const $ = jQuery(window);

export default $;
