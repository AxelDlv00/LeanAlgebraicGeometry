---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:cechPicEquivPic
lean_status: lean_ok
order: 781
title: The \v Cech--Picard dictionary
type: tex
updated: '2026-07-17T18:01:33'
---
For every affine scheme \(X\) with global ring \(A = \Gamma(X,\struct X)\), the descent
  homomorphism of Definition~\ref{def:cechPic_toPic} is an isomorphism of groups
  \[
    \operatorname{toPic} \colon \Pic(X) \;\xrightarrow{\ \sim\ }\; \operatorname{Pic}(A).
  \]
  In particular the definitional \v Cech Picard group \(\Pic(X)\) on pointed Zariski covers of
  \(X\) is canonically isomorphic to mathlib's Picard group of invertible \(A\)-modules.