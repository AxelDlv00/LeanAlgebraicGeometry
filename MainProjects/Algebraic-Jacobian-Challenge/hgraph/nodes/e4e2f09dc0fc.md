---
author: sync
chapter: The tautological quotient and the universal property of $\mathrm{Gr}(r,d)$
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:gr_bundleCocycle_transport
lean_status: lean_ok
order: 1514
title: Transport and endpoint alignment of the bundle transitions
type: tex
updated: '2026-07-28T18:12:22'
---
Fix indices \(I, J, K\) with triple overlap \(V_{IJK} = U^I_J \times_{U^I} U^I_K\),
  and let \(\widehat{g}_{IJ}^{\,K}, \widehat{g}_{JK}^{\,I}, \widehat{g}_{IK}^{\,J}\) be
  the base-change transports (\cref{lem:modules_pullback_basechange_transport}) of the
  three bundle transitions to \(V_{IJK}\). Under the free-pullback comparisons
  (\cref{lem:gr_pullbackFreeIso}) and the endpoint bridges
  (\cref{lem:gr_glueData_bridges}), each transported transition is identified with the
  matrix automorphism of the corresponding base-changed Cramer inverse on the common
  free sheaf \(\mathcal{O}_{V_{IJK}}^{\,d}\); granting the matrix identity
  \cref{lem:gr_bundleCocycle_matrix}, the composite satisfies
  \[
    \widehat{g}_{JK}^{\,I} \circ \widehat{g}_{IJ}^{\,K}
      \;=\; \widehat{g}_{IK}^{\,J}
  \]
  as isomorphisms of sheaves of modules on \(V_{IJK}\). This is the substantive
  transport step: the alignment of the three transports' domains and codomains.