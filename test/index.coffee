import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"
import { request } from "./helpers"

h = { assert, test, request }

import basic from "./basic"

do ->

  print await test "Lambda HTTP Echo", [

    ( basic h )...

  ]

  process.exit if success then 0 else 1
