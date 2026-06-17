# Blueprint-writer directive — chapter `Cohomology_CechHigherDirectImage.tex` (Route B B3 expansion + coverage debt)

You edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. Do NOT add `\leanok` (the
deterministic sync phase owns it). Use `\mathlibok` ONLY on genuine Mathlib re-export anchors, never on a
project-proved declaration.

## Strategy context (the slice that matters)

Route B (01I8: quasi-coherent `F ≅ ~(ΓF)` on an affine `Spec R`) computes the keystone
`lem:qcoh_section_isLocalizedModule` through a `\uses`-linked sub-lemma chain B0–B6. Entering this iter
**B1 and B2 are DONE** (`lem:qcoh_finite_presentation_cover`, `lem:presentation_over_basicOpen`); the
single remaining load-bearing build is **B3** `lem:restrict_over_compat`
(`\lean{AlgebraicGeometry.overBasicOpenIsoRestrict}`), with B4 mechanical after it. The prover attempted
B3, discharged its site-equivalence (IsContinuous) half, and stopped on the structure-sheaf compatibility
datum, leaving a precise B3a/B3b/B3c decomposition. The blueprint's B3 proof sketch is currently too
high-level for the next prover (it does not name this decomposition). Your job is to make the blueprint
B3 sketch carry that decomposition, close the related coverage debt, and tighten two `\uses` lists.

## Tasks (four precise edits — make exactly these, change nothing else mathematically)

### Task 1 — Add a Mathlib-anchor + project-infra block for the `overEquivalence` continuity quartet

In the "Route B: Mathlib dependency anchors" section (near line 3951, after
`lem:pushforwardPushforwardEquivalence_mathlib`), add TWO blocks:

(a) A `\mathlibok` anchor for the site equivalence ITSELF:
```
\begin{lemma}[The over-site of a topological space is equivalent to its subspace site]
  \label{lem:overEquivalence_mathlib}
  \lean{TopologicalSpace.Opens.overEquivalence}
  \mathlibok
  \textit{Provided by Mathlib.}
  For a topological space \(T\) and an open \(U \subseteq T\), the over-category
  \((\operatorname{Opens} T).\operatorname{over} U\) of opens contained in \(U\) is equivalent to the
  category \(\operatorname{Opens} U\) of opens of the subspace \(U\).
\end{lemma}
```

(b) A NORMAL project block (NO `\mathlibok` — these are project-proved lemmas that close a Mathlib
`## TODO`) pinning all four continuity declarations:
```
\begin{lemma}[Continuity of the over-site equivalence]
  \label{lem:overEquivalence_isContinuous}
  \lean{AlgebraicGeometry.Opens.overEquivalence_functor_coverPreserving,
    AlgebraicGeometry.Opens.overEquivalence_inverse_coverPreserving,
    AlgebraicGeometry.Opens.overEquivalence_functor_isContinuous,
    AlgebraicGeometry.Opens.overEquivalence_inverse_isContinuous}
  \uses{lem:overEquivalence_mathlib}
  Both functors of the over-site equivalence
  \((\operatorname{Opens} T).\operatorname{over} U \simeq \operatorname{Opens} U\) of
  Lemma~\ref{lem:overEquivalence_mathlib} are cover-preserving and continuous for the respective
  Grothendieck topologies of pointwise covers. (Mathlib supplies the equivalence but leaves its
  continuity as a TODO; these four declarations close it, and they are exactly what the site-equivalence
  transport of step B3 requires.)
\end{lemma}
\begin{proof}
  \uses{lem:overEquivalence_mathlib}
  The opens Grothendieck topology is the pointwise-cover predicate; the over-topology unfolds via
  `GrothendieckTopology.mem_over_iff`, and the subspace-versus-image point correspondence is the
  obvious \(\langle x', hx'\rangle\) / `Subtype.val` bookkeeping, giving cover-preservation of each
  functor. Continuity then follows from cover-preservation together with the cover-density,
  local-fullness and local-faithfulness that hold automatically for the fully-faithful, essentially
  surjective functors of an equivalence (`Functor.IsCoverDense.isContinuous`).
\end{proof}
```

### Task 2 — Expand the B3 proof sketch (`lem:restrict_over_compat`, near line 4100) with B3a/B3b/B3c

Keep the statement block unchanged. Replace the proof block's `\uses{...}` with
```
\uses{lem:modules_restrict_basicOpen, lem:pushforwardPushforwardEquivalence_mathlib,
  lem:restrict_obj_mathlib, lem:overEquivalence_isContinuous}
```
and rewrite the proof PROSE so it names the three sub-steps the prover identified (this is the mathematical
content the next prover must follow — transcribe it faithfully, in project notation, no Lean tactic
strings):

- **B3a (the structure-sheaf compatibility datum).** The two ring sheaves are genuinely different
  presentations of the structure sheaf: `S = (Spec R).ringCatSheaf.over D(g)` on the over-site
  (sections over `V` are `Γ(Spec R, V.left)`), versus the subscheme structure sheaf
  `(↥D(g)).ringCatSheaf` on `Opens ↥D(g)` (sections over `W` are `Γ(Spec R, val ''ᵁ W)`). They agree on
  sections by the open immersion, and the comparison morphism `φ`/`ψ` (with coherence `H₁`/`H₂`) is built
  from the open-immersion structure-sheaf isomorphism `Scheme.Hom.appIso` of the inclusion
  `(specBasicOpen g).ι` — the SAME `appIso` that `Scheme.Modules.restrictFunctor` uses to build its ring
  map. Emphasize: this is genuine geometric content, NOT a `map_id`-triviality (contrast with B2, where
  both ring sheaves were `over` of the same base and related by `R.1.map_id`).
- **B3b (the module equivalence on the subspace).** Feed `φ`/`ψ`/`H₁`/`H₂` and the now-continuous site
  equivalence (Lemma~\ref{lem:overEquivalence_isContinuous}) to
  `pushforwardPushforwardEquivalence` (Lemma~\ref{lem:pushforwardPushforwardEquivalence_mathlib}),
  obtaining an equivalence `(↥D(g)).Modules ≌ SheafOfModules ((Spec R).ringCatSheaf.over D(g))` whose
  object map sends the subscheme restriction `F.restrict (specBasicOpen g).ι` to the over-picture object
  `F.over D(g)` (sections agree by `restrict_obj`, Lemma~\ref{lem:restrict_obj_mathlib}).
- **B3c (transport to `Spec R_g` and assemble).** Transport from the subscheme `↥D(g)` to the affine
  `Spec R_g` along the iso `basicOpenIsoSpecAway g` (restriction along an iso is an in-framework
  equivalence of `.Modules`), landing on `modulesRestrictBasicOpen g F` (definitionally the double
  restrict, Lemma~\ref{lem:modules_restrict_basicOpen}). Compose the B3b object iso with this transport to
  get the bridge `F.over D(g) ≅ modulesRestrictBasicOpen g F`.

Keep the existing closing paragraph that records B3 is distinct from `lem:tilde_restrict_basicOpen` and
is NOT discharged by `lem:modules_restrict_basicOpen`.

### Task 3 — Tighten the B2 proof `\uses` (`lem:presentation_over_basicOpen`, near line 4089)

The B2 proof block currently cites only `\uses{lem:presentation_map_mathlib}`, but the formalized proof
also materially uses `pushforwardPushforwardEquivalence` and `Presentation.ofIsIso`. Change the B2 PROOF
block's `\uses` to:
```
\uses{lem:presentation_map_mathlib, lem:pushforwardPushforwardEquivalence_mathlib,
  lem:presentation_ofIsIso_mathlib}
```
and add one sentence to the B2 proof prose noting that the transport is realized by first building the
site equivalence via `pushforwardPushforwardEquivalence`, transporting through its inverse with
`Presentation.map`, and closing with `Presentation.ofIsIso`. (Leave the statement block's `\uses`
unchanged.)

### Task 4 — Bundle the private helper `coversTop_iSup_eq_top` into B1's `\lean{}`

The B1 lemma `lem:qcoh_finite_presentation_cover` (near line 4058) currently pins only
`\lean{AlgebraicGeometry.qcoh_finite_presentation_cover}`. The prover added a private helper
`AlgebraicGeometry.coversTop_iSup_eq_top` (the `J.CoversTop Y → ⨆ Y = ⊤` translation it uses). Append it
to that `\lean{}` list so the helper is covered:
```
\lean{AlgebraicGeometry.qcoh_finite_presentation_cover, AlgebraicGeometry.coversTop_iSup_eq_top}
```
Do not change B1's statement, proof prose, or `\uses`.

## Out of scope
- Do NOT touch any block other than the four named above and the one new anchor pair.
- Do NOT add/remove `\leanok` anywhere.
- Do NOT rewrite the keystone `lem:qcoh_section_isLocalizedModule` or any `Route A` / P5 / 02KG content.
- Do NOT introduce new theorems beyond the two new blocks of Task 1.

## Verification you should report
List, for each task, the line range you edited and the final `\uses`/`\lean` lists, so the planner can
confirm the coverage debt (4 `overEquivalence` decls + `coversTop_iSup_eq_top`) is now matched and B3's
sketch carries the B3a/B3b/B3c decomposition.
