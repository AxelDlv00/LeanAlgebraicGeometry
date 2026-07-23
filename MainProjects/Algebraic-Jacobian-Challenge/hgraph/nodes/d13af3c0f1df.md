---
author: sync
chapter: FGA representability of the Picard scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:pic_scheme_lft
lean_status: empty
order: 1541
title: 'Carrier: \(\Pic_{C/k}\) is locally of finite type'
type: tex
updated: '2026-07-16T21:14:30'
---
The predicate \(\mathrm{PicSchemeLocallyOfFiniteType}(C)\) asserts that the
  structural morphism of the Picard scheme \(\Pic_{C/k}\) of
  \cref{def:pic_scheme} is locally of finite type --- part (1) of Kleiman
  \S 4, Thm.~th:main (\(\Pic_{C/k}\) is a disjoint union of open
  quasi-projective \(k\)-subschemes). It is the hypothesis the
  identity-component substrate of
  \cref{chap:Picard_IdentityComponent} consumes to specialise
  \(G^0\) to \(G = \Pic_{C/k}\). Since the run-0010 strengthening of
  \cref{def:has_pic_scheme}, its instance \cref{def:inst_pic_scheme_lft}
  is proved by extraction, and the class survives only to preserve the
  consumer signature.