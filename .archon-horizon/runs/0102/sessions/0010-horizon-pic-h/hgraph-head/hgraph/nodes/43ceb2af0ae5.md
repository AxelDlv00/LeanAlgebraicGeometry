---
author: sync
chapter: Cohomology of sheaves of modules
content_type: theorem
created: '2026-07-17T08:59:07'
generated: blueprint
label: thm:curveH1CokBaseChange
lean_status: lean_ok
order: 491
title: Base change of the two-cover \(H^1\) cokernel of the curve
type: tex
updated: '2026-07-17T16:57:16'
---
For every commutative \(k\)-algebra \(R\) there is an \(R\)-linear equivalence
  \[
    R \otimes_k \mathrm{H1Cok}(C; V_0, V_1) \;\cong\;
      \mathrm{H1Cok}(C_R; V_0^R, V_1^R),
  \]
  sending \(a \otimes [s]\) to \([a \cdot \mathrm{pr}_1^\sharp(s)]\). No flatness of
  \(R\) is needed.