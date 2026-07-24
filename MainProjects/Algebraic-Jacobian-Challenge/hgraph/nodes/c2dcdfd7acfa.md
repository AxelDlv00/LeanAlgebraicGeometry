---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:tensorObjUnitIso_hom_sectionsMul
lean_status: lean_ok
order: 1295
title: Left unitor through the section multiplication
type: tex
updated: '2026-07-24T10:32:51'
---
Let \(G\) be a sheaf of \(\mathcal{O}_X\)-modules and \(a \in \Gamma(X, G)\).
  Then
  \[
    \Gamma\bigl(\mathrm{tensorObjUnitIso}_G\bigr)
      \bigl(\mathrm{sectionsMul}_{\mathbf{1}_X, G}(1 \otimes a)\bigr) = a,
  \]
  i.e.\ applying global sections of the left unitor
  \(\mathbf{1}_X \otimes_{\mathcal{O}_X} G \xrightarrow{\sim} G\)
  (\cref{def:tensorObjUnitIso}) to the section product of the unit section
  \(1 \in \Gamma(X,\mathcal{O}_X)\) and \(a\) (\cref{def:sectionMul}) returns
  \(a\). This is the section-level reading of the left-unit law via
  \(\eta\)-naturality of the lax structure.