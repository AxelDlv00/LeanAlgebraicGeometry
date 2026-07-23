---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:higher_direct_image_presheaf
lean_status: lean_ok
order: 403
title: Presheaf description of the higher direct images
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Source: Stacks Project, Cohomology, Tag 01XJ
  (\texttt{lemma-describe-higher-direct-images}).}
  Let \(f : X \to S\) be a morphism of schemes and \(\mathcal{G}\) an
  \(\mathcal{O}_X\)-module, and assume the category of \(\mathcal{O}_X\)-modules has
  enough injective objects, so that the derived pushforward \(R^k f_*\) is defined.
  Choose an injective resolution \(\mathcal{G} \to \mathcal{I}^\bullet\) in
  \(\mathcal{O}_X\)-modules and push it forward degreewise to obtain the cochain complex
  of presheaves of modules \(f_*\mathcal{I}^\bullet\) on \(S\). For every \(k \geq 0\)
  the higher direct image \(R^k f_*\mathcal{G}\) is isomorphic to the
  \emph{sheafification of the presheaf of objectwise homology} of this pushed complex,
  \[
    R^k f_*\mathcal{G}
      \;\cong\;
    \operatorname{sheafify}\Bigl(\,V \longmapsto
      H^k\bigl((f_*\mathcal{I}^\bullet)(V)\bigr)\,\Bigr),
    \qquad V \subseteq S \text{ open},
  \]
  the sheafification of the \(k\)-th presheaf-level homology of
  \(f_*\mathcal{I}^\bullet\). As a closing remark, this gives the affine-local
  vanishing criterion consumed downstream
  (Lemmas~\ref{lem:open_immersion_pushforward_comp} and
  \ref{lem:cech_term_pushforward_acyclic}): since the sheafification of a presheaf
  vanishes exactly when that presheaf vanishes on a basis of opens,
  \(R^k f_*\mathcal{G} = 0\) iff \(H^k\bigl((f_*\mathcal{I}^\bullet)(V)\bigr) = 0\)
  for every \(V\) in a basis of the topology of \(S\); the affine opens form such a
  basis, so it suffices to check the vanishing on affine \(V\).

  The identification of the displayed presheaf homology with the absolute cohomology
  of the preimage,
  \[
    H^k\bigl((f_*\mathcal{I}^\bullet)(V)\bigr)
      \;=\;
    H^k\bigl(f^{-1}(V), \mathcal{G}|_{f^{-1}(V)}\bigr),
  \]
  which uses that \(\mathcal{I}^\bullet|_{f^{-1}(V)}\) is again injective over
  \(f^{-1}(V)\), is supplied at point of use; this lemma records the
  resolution-internal sheafify-of-objectwise-homology form.