import { App } from "astal"
import style from "./styles/style.scss"
import Bar from "./widget/Bar"

App.start({
    css: style,
    main: () => App.get_monitors().map(Bar),
})
