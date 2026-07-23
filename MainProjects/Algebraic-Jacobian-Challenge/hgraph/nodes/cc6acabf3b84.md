---
author: sync
chapter: 'Milne Theorem 3.2: Rational maps into abelian varieties'
content_type: remark
created: '2026-07-16T21:14:30'
generated: blueprint
label: rmk:thm32_role_of_ab
lean_status: empty
order: 1736
title: rmk:thm32_role_of_ab
type: tex
updated: '2026-07-16T21:14:30'
---
\textbf{Where Auslander--Buchsbaum enters.} The combination above relies on
  \cref{thm:codim_one_extension}, which is itself proved in
  \cref{chap:Albanese_CodimOneExtension} in two stages: a codim-\(1\) step
  (valuative criterion of properness, applied at the DVR
  \(\mathcal O_{X, Z}\) of each codimension-\(1\) point \(Z\) --- works because \(X\) is normal
  and \(A\) is complete) and a codim-\(\geq 2\) step (depth-\(\geq 2\) at codim-\(\geq 2\) points,
  giving the local-cohomology / Hartshorne~III.8 sheaf-extension property). The
  depth-\(\geq 2\) input on a smooth (regular) variety is exactly what
  \cref{cor:regular_cohen_macaulay} of \cref{chap:Albanese_AuslanderBuchsbaum} supplies:
  for a regular local ring \((\mathcal O_{X, x}, \mathfrak m_x)\) of Krull dimension \(d\), the
  Auslander--Buchsbaum formula \cref{thm:auslander_buchsbaum} (applied to \(M = R\)
  trivially, or to the depth-via-regular-sequence characterisation directly) gives
  \(\mathrm{depth}(\mathcal O_{X, x}) = d\), so in particular
  \(\mathrm{depth}(\mathcal O_{X, x}) \geq 2\) whenever \(\mathrm{codim}_X(\{x\}) \geq 2\).
  Concretely, when \(X\) is a smooth surface (e.g.\ \(\mathbb P^1 \times \mathbb P^1\) or
  \(C \times C\) for a smooth projective curve \(C\)), every closed point \(x\) is regular of
  dimension \(2\), so \(\mathcal O_{X, x}\) is Cohen--Macaulay of depth \(2\); sections of
  \(\mathcal O_X\) on \(U = X \setminus \{x\}\) extend uniquely across \(x\), and the same is
  true for affine-locally pulled-back sections of \(\mathcal O_A\) along \(f\).

  Auslander--Buchsbaum therefore does not appear by name in the proof above; it appears
  inside \cref{thm:codim_one_extension}'s codim-\(\geq 2\) half. The
  \cref{thm:auslander_buchsbaum} dependency is recorded on
  \cref{thm:rational_map_to_av_extends} to keep the leanblueprint dependency graph
  faithful: A.4.c truly does sit on top of A.4.b through A.4.a.