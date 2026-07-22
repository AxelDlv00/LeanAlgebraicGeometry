---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:comparisonDescentClass_mapAlgebra
lean_status: lean_ok
order: 960
title: Base-change naturality of the descent extraction
type: tex
updated: '2026-07-17T18:01:33'
---
Let \(S \to S'\) be a map of \(A\)-algebras and \(v\) a coherent comparison unit over \(S\). The
  class descended over \(S'\) from the base-changed comparison \((\mathrm{algebraMap} \otimes \id)(v)\)
  is the \(\operatorname{Pic}\)-image of the class descended over \(S\):
  \[
    \mathrm{comparisonDescentClass}_{S'}\bigl((\mathrm{algebraMap} \otimes \id)(v)\bigr)
      \;=\; \operatorname{Pic.mapAlgebra}_{S \to S'}\bigl(\mathrm{comparisonDescentClass}_S(v)\bigr).
  \]