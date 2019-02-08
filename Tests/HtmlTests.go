package GoldLibrary.Tests.Shared

import (
	"html"
	"html/template"
	"fmt"
)

func DoHtmlUnescapeStringTest() String {
	const s = `&quot;Fran &amp; Freddie&#39;s Diner&quot; &lt;tasty@example.com&gt;`
	return html.UnescapeString(s)
}

func DoHtmlEscapeStringTest(aVal String) String {
	return html.EscapeString(aVal);
}

func DoHtmlTemplatesTest()
{
	const tpl = `
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>{{.Title}}</title>
	</head>
	<body>
		{{range .Items}}<div>{{ . }}</div>{{else}}<div><strong>no rows</strong></div>{{end}}
	</body>
</html>`

check := func(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
t, err := template.New("webpage").Parse(tpl)
check(err)
}