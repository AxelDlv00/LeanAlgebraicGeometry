---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:coreIso_comm_coface
lean_status: lean_ok
order: 381
title: Per-coface square of the core comparison
type: tex
updated: '2026-07-16T21:14:29'
---
With the notation of Lemma~\ref{lem:coreIso_obj_iso}, for each degree \(p\) and each coface
  index \(k \le p+1\) the individual cofaces are intertwined by the object isomorphisms:
  \[
    (\mathrm{objIso}\,p).\mathrm{hom} \cdot \delta^{\mathrm{sec}}_k
      \;=\;
    G_V\bigl(\Psi(\delta^{\mathrm{nerve}}_k)\bigr) \cdot (\mathrm{objIso}\,(p+1)).\mathrm{hom},
  \]
  where \(\delta^{\mathrm{sec}}_k\) is the \(k\)-th section-{\v C}ech coface and
  \(\delta^{\mathrm{nerve}}_k\) the \(k\)-th {\v C}ech-nerve coface of the backbone, both maps
  into the degree-\((p+1)\) term.