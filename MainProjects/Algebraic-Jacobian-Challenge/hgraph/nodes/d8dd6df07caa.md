---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:tensorObjAssoc_hom_sectionsMul
lean_status: lean_ok
order: 1315
title: Associator through the section multiplication
type: tex
updated: '2026-07-27T20:11:17'
---
Let \(\mathcal{A}, \mathcal{B}, \mathcal{C}\) be sheaves of
  \(\mathcal{O}_X\)-modules and \(a \in \Gamma(X,\mathcal{A})\),
  \(b \in \Gamma(X,\mathcal{B})\), \(c \in \Gamma(X,\mathcal{C})\). Applying global
  sections of the associator (\cref{cor:sheafTensorObjAssoc}) to the iterated
  section product reassociates the three factors:
  \[
    \Gamma\bigl(\mathrm{tensorObjAssoc}_{\mathcal{A},\mathcal{B},\mathcal{C}}\bigr)
      \Bigl(\mathrm{sectionsMul}\bigl(
        \mathrm{sectionsMul}(a \otimes b) \otimes c\bigr)\Bigr)
      = \mathrm{sectionsMul}\bigl(a \otimes \mathrm{sectionsMul}(b \otimes c)\bigr),
  \]
  i.e.\ \(\Gamma(\alpha)\) sends \((a \otimes b) \otimes c\) to
  \(a \otimes (b \otimes c)\) at the level of section multiplications. This is the
  \(\eta\)-naturality of the lax structure pushing the associator through
  \(\mathrm{sectionsMul}\), the section-level partner of the associativity
  constraint \cref{lem:tensorPowAdd_assoc}.