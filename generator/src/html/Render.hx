package html;

using Literals;

class Render {
	public static function fileBanner(
			tool:{ commit:Html, haxe:Html, runtime:Html, platform:Html },
			logo:{ art:Html, text:Html }):Html
	{
		return new Html('
				<!--
					DO NOT EDIT THIS FILE MANUALLY!

					This file has been automatically generated from manuscript sources
					using the *manu* tool:
						tool version: ${tool.commit}
						haxe version: ${tool.haxe}
						runtime: ${tool.runtime}
						platform: ${tool.platform}
					
					${logo.art}   ${logo.text}
				-->
				'.doctrim());
	}

	public static function tocItem(vno:Null<Int>, lno:Html, name:Html, url:Html):Html
	{
		return new Html(
			if (vno != null)
				'<a href="${url}" class="volume${vno}">${lno} ${name}</a>\n';
			else if (lno != null)
				'<a href="${url}">${lno} ${name}</a>\n';
			else
				'<a href="${url}">${name}</a>\n');
	}

	public static inline function posAttr(pos:Position):Html
	{
		// TODO if god: something like saving `exportPos(pos)` in data-pos attribute
		return new Html("");
	}

	public static inline function head(title:Html, base:Html, relPath:Html, ?append:Iterable<Html>):Html
	{
		// note: mathjax styling done here because of MathZoom inner workings
		// note: missing blur on out of focus elements (maybe check "math zoomed" and "math unzoomed" events)
		// note: manual mathjax settings override these; to clean, remove the mjx.menu cookie
		var buf = new StringBuf();
		buf.add('
				<head>
				<meta charset="utf-8">
				<title>${title}</title>
				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<base href="${base}" id="docbase">
				<link rel="canonical" href="${relPath}">
				<!-- Jquery -->
				<script src = "https://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js" ></script>
				<!-- MathJax -->
				<script type="text/x-mathjax-config">
				MathJax.Hub.Config({
					CommonHTML: {
						mtextFontInherit: true,
						linebreaks: { automatic: true }
					},
					"HTML-CSS": {
						mtextFontInherit: true,
						linebreaks: { automatic: true }
					},
					SVG: {
						mtextFontInherit: true,
						linebreaks: { automatic: true }
					},
					tex2jax: {
						ignoreClass: ".+",
						processClass: "mathjax"
					},
					menuSettings:{
						zoom: "Click"
					},
					MathZoom: {
						styles: {
							"#MathJax_Zoom":{"z-index":"1000","cursor":"pointer","cursor":"zoom-out" },
							"#MathJax_ZoomOverlay": {"opacity":"0.75","background":"rgba(127,127,127,0.75)","z-index":"999","cursor":"pointer","cursor":"zoom-out" }
						}
					}
				});
				</script>
				<script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS_CHTML"></script>
				'.doctrim());
		if (append != null) {
			buf.add("<!-- Custom HEAD elements -->\n");
			for (i in append) {
				buf.add(i);
				buf.add("\n");
			}
		}
		buf.add("</head>\n");
		return new Html(buf.toString());
	}

	public static function breadcrumbs(bcs:Breadcrumbs, rootUrl:Html, relPath:Html):Html
	{
		var buf = new StringBuf();
		buf.add('
				<header><ul>
				<li><a class="brtcolor" href="${rootUrl}">BRT Planning Guide</a></li>
				'.doctrim());
		if (bcs.volume != null)
			buf.add('
					<li class="slash">/</li>
					<li><a class="volume${bcs.volume.no}" href="${bcs.volume.url}">${bcs.volume.name}</a></li>
					'.doctrim());
		if (bcs.chapter != null)
			buf.add('
				<li class="slash">/</li>
				<li><a href="${bcs.chapter.url}">${bcs.chapter.name}</a></li>
					'.doctrim());
		if (bcs.section != null)
			buf.add('
				<li class="slash">/</li>
				<li><a href="${bcs.section.url}">${bcs.section.name}</a></li>
					'.doctrim());
		buf.add('
				<li class="jump-to-nav"><a href="${relPath}#action:navigate">...</a></li>
				</ul>
				<noscript>
				<div class="js-required-banner">
						JavaScript required, but not enabled.  Please check your browser settings.
				</div>
				</noscript>
				</header>
				'.doctrim());
		return new Html(buf.toString());
	}
}

