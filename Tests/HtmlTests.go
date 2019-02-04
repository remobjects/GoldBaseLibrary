package GoldLibrary.Tests.Shared

import (
	"html"
	"fmt"
)

func DoHtmlUnescapeStringTest() String {
	const s = `&quot;Fran &amp; Freddie&#39;s Diner&quot; &lt;tasty@example.com&gt;`
	return html.UnescapeString(s)
}