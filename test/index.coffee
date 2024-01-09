import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import * as _h from "./helpers"

h = { test, _h... }

import basic from "./basic"

do ->

  print await test "Lambda HTTP Echo", [

    ( basic h )...

  ]

  process.exit if success then 0 else 1
