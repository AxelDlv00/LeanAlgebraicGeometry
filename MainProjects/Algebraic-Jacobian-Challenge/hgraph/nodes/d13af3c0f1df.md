---
author: sync
chapter: FGA representability of the Picard scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:pic_scheme_lft
lean_status: lean_ok
order: 1556
title: Local finite type of \(\Pic_{C/k}\)
type: tex
updated: '2026-07-27T19:45:43'
---
The predicate
  \[
    \mathrm{PicSchemeLocallyOfFiniteType}(C)
  \]
  asserts that the
  structural morphism of the Picard scheme \(\Pic_{C/k}\) of
  \cref{def:pic_scheme} is locally of finite type --- part (1) of Kleiman
  \S 4, Thm.~th:main (\(\Pic_{C/k}\) is a disjoint union of open
  quasi-projective \(k\)-subschemes). It is the hypothesis the
  identity-component construction of
  \cref{chap:Picard_IdentityComponent} uses to specialise
  \(G^0\) to \(G = \Pic_{C/k}\). It follows from the local-finiteness
  component of \cref{def:has_pic_scheme}.