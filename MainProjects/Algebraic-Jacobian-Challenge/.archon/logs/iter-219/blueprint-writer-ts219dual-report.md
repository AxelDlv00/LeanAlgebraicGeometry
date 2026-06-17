# Blueprint Writer Report

## Slug
ts219dual

## Status
COMPLETE — all four EDITs applied to `Picard_TensorObjSubstrate.tex`; chapter remains valid LaTeX (non-comment environments balance 23/23 lemma, 7/7 definition, 22/22 proof, 3/3 remark, 1/1 theorem).

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex (the only file edited)

## Changes Made

### EDIT 1 [MUST-FIX] — `lem:tensorobj_inverse_invertible` proof reframed as INFRASTRUCTURE-BLOCKED
- **Revised** proof of `lem:tensorobj_inverse_invertible`: replaced the misleading
  "Set \(L^{-1} := \mathcal{H}om(L,\mathcal{O}_X)\) … we construct" opening with an
  explicit **`\textbf{Infrastructure-blocked.}`** paragraph stating the construction
  depends on a sheaf internal hom of \(\mathcal{O}_X\)-modules absent at presheaf /
  sheaf / categorical level, so \(L^{-1}\) cannot even be *named* today and the Lean
  body is a placeholder.
- Tense changed from "we construct" to "We record the intended mathematical route …
  *The route is as follows.*" The three Steps' mathematical content (dual =
  `ℋom(L,𝒪_X)`, contraction = evaluation = local left-unitor, local-iso ⇒ global via
  the CLOSED `tensorObj_restrict_iso`) is retained unchanged.
- Cross-references the new dual section: now points `Linv` and `ε_L` at
  `lem:internal_hom_isSheaf` / `lem:internal_hom_eval`, and the closing paragraph cites
  `\cref{sec:tensorobj_dual_infra}` and `lem:dual_isLocallyTrivial` as the prerequisite
  realization.
- `\uses{}` of the proof extended with `lem:internal_hom_eval, lem:dual_isLocallyTrivial`.

### EDIT 2 [MAJOR] — `lem:tensorobj_assoc_iso` route-mismatch note added
- **Revised** proof of `lem:tensorobj_assoc_iso`: inserted a visible
  **`\textbf{Status (route mismatch, deferred).}`** paragraph stating (a) the current
  Lean realization uses the route-(d) whiskering composite
  (`whisker_of_W`/`islocallyinjective_whisker_of_W` + `isiso_sheafification_map_of_W`)
  and is therefore NOT axiom-clean (transitive open obligation via the unproved
  left-whiskering component), and (b) the gluing route described below is the intended
  obligation-free realization but needs morphism-level descent for `SheafOfModules` —
  the same descent-infrastructure family the dual block needs — so the assoc re-route
  and the whiskering/stalk deletion are deferred *jointly* with the dual block
  (`\cref{sec:tensorobj_dual_infra}`).

### EDIT 3 [MINOR] — retracted inaccurate "removed in iter-218" wording
- **Revised** all 6 `% SUPERSEDED route … Lean declaration removed in iter-218 …`
  comment lines (replace-all) to: "… pending deletion once the assoc re-route
  (morphism-level descent) lands. Declaration still present and still backing the
  current `tensorObj_assoc_iso` proof."
- **Revised** the two prose lines that made the same inaccurate "its Lean declarations
  are being removed" claim (intro of the two superseded-block headers) to "pending
  deletion … and until then remain present (the current `tensorObj_assoc_iso` still
  calls them)".

### EDIT 4 [NEW SECTION] — `\section{Sheaf internal-hom of 𝒪_X-modules …}` appended
New section `\label{sec:tensorobj_dual_infra}` decomposing the Decision-1 build, with a
structural intro explaining the contravariance problem and the slice-formula remedy.
Six blocks:
1. `\definition` `\label{def:presheaf_internal_hom}` `\lean{PresheafOfModules.internalHom}`
   `\uses{def:scheme_modules_tensorobj}` — slice formula
   `ℋom(M,N)(U) := ModuleCat.of (R(U)) (M|_U ⟶ N|_U)`; prose explains why the pointwise
   rule is contravariant and the slice rule is covariant. SOURCED (Stacks Internal Hom).
2. `\definition` `\label{def:presheaf_dual}` `\lean{PresheafOfModules.dual}`
   `\uses{def:presheaf_internal_hom}` — `M^∨ := ℋom(M,R)`; project-bespoke
   specialisation (no separate quote).
3. `\lemma` `\label{lem:internal_hom_eval}` `\lean{PresheafOfModules.internalHomEval}`
   `\uses{def:presheaf_dual, def:scheme_modules_tensorobj}` — evaluation
   `M ⊗_R M^∨ → R`, `s⊗φ ↦ φ(s)`, with proof sketch. SOURCED (evaluation morphism).
4. `\lemma` `\label{lem:internal_hom_isSheaf}` `\lean{AlgebraicGeometry.Scheme.Modules.dual}`
   `\uses{def:presheaf_dual, lem:internal_hom_eval}` — sheaf condition ⇒ descends to
   `Scheme.Modules`; defines sheaf-level `dual M`, with proof sketch. SOURCED (sheaf-of-modules).
5. `\lemma` `\label{lem:dual_isLocallyTrivial}`
   `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`
   `\uses{lem:internal_hom_isSheaf, lem:tensorobj_restrict_iso}` — dual of a line
   bundle is a line bundle, with proof sketch. SOURCED (Stacks 01CR item 2).
6. `\remark` `\label{rem:dual_discharges_inverse}` — explicit statement of how the
   five blocks discharge `lem:tensorobj_inverse_invertible` (`Linv := dual L`, `eval`
   local iso = left unitor ⇒ global iso). `\uses{lem:tensorobj_inverse_invertible,
   lem:dual_isLocallyTrivial, lem:internal_hom_eval, lem:tensorobj_restrict_iso,
   lem:tensorobj_unit_iso}`.
- Plus `\remark` `\label{rem:dual_via_stack}` — one-paragraph fallback note on the
  Decision-3 `Pseudofunctor.IsStack` object-descent route (no full sub-steps), tying it
  to the same descent family as the assoc re-route.

## New `\label{}` / `\lean{}` pins added
- `sec:tensorobj_dual_infra` (section)
- `def:presheaf_internal_hom` → `\lean{PresheafOfModules.internalHom}`
- `def:presheaf_dual` → `\lean{PresheafOfModules.dual}`
- `lem:internal_hom_eval` → `\lean{PresheafOfModules.internalHomEval}`
- `lem:internal_hom_isSheaf` → `\lean{AlgebraicGeometry.Scheme.Modules.dual}`
- `lem:dual_isLocallyTrivial` → `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`
- `rem:dual_discharges_inverse` (no `\lean{}`)
- `rem:dual_via_stack` (no `\lean{}`)

(The `\lean{}` names for blocks 1, 3, 4, 5 are the planner-chosen INTENDED targets from
the directive; block 5's pin `…dual_isLocallyTrivial` was not pinned in the directive,
so I chose a name consistent with the directive's `…dual` namespace — flag if a
different name is preferred.)

## Cross-references introduced
- `lem:tensorobj_inverse_invertible` proof now `\uses` `lem:internal_hom_eval`,
  `lem:dual_isLocallyTrivial` (both new, in this chapter).
- New blocks' `\uses` edges (all targets in this chapter): `def:scheme_modules_tensorobj`,
  `def:presheaf_internal_hom`, `def:presheaf_dual`, `lem:internal_hom_eval`,
  `lem:internal_hom_isSheaf`, `lem:tensorobj_restrict_iso`, `lem:tensorobj_unit_iso`,
  `lem:tensorobj_inverse_invertible` — all exist in this chapter; verified present.

## References consulted
- `references/stacks-modules.tex` — verbatim `% SOURCE QUOTE:` for `def:presheaf_internal_hom`
  (§Internal Hom opening, L3500–3524: slice rule + sheaf-of-modules + evaluation morphism),
  for `lem:internal_hom_eval` (L3517–3524, evaluation), for `lem:internal_hom_isSheaf`
  (L3502–3514, sheaf condition), and for `lem:dual_isLocallyTrivial` (L4207–4211,
  Lemma `lemma-constructions-invertible` item 2 — verified character-by-character).
- `references/summary.md` — index; confirmed `stacks-modules.tex` is the canonical
  local source for tag 01CR / §Internal Hom (tag area 01CM).

## Macros needed (if any)
- None added. Avoided introducing an undefined `\ihom` macro: rewrote the two
  fixed-ring internal-hom mentions in the section intro as `\mathtt{ihom}` (plain).
  All other commands used (`\Scheme`, `\Pic`, `\Opens`, `\mathcal{H}om`, `\mathtt`,
  `\mathsf`, `\mathbf`) are already defined / standard and used elsewhere in the chapter.

## Reference-retriever dispatches (if any)
- None. The Stacks "Modules on Ringed Spaces" chapter (incl. §Internal Hom and tag
  01CR) was already on disk at `references/stacks-modules.tex`; no retrieval needed.

## Notes for Plan Agent
- **Pre-existing LaTeX is sound.** A raw `grep` of `\begin{lemma}`/`\end{lemma}` shows
  27/26, but the surplus is three *commented* `% "\begin{lemma}` lines inside existing
  SOURCE-QUOTE blocks (L1604, L1853, L1906); excluding comment lines the environments
  balance exactly (23/23 lemma, 7/7 def, 22/22 proof, 3/3 remark, 1/1 theorem). I did
  not introduce or alter these; flagged only so the imbalance is not mistaken for a new
  defect.
- The `\lean{AlgebraicGeometry.Scheme.Modules.dual}` pin on `lem:internal_hom_isSheaf`
  and the `…dual_isLocallyTrivial` pin on `lem:dual_isLocallyTrivial` are the natural
  realization names; if the scaffolder prefers a `SheafOfModules`-level namespace,
  adjust the pins before prover assignment.

## Strategy-modifying findings
None. The decomposition confirms (does not contradict) the strategy: the
`exists_tensorObj_inverse` PRIMARY remains blocked on a Mathlib-absent sheaf internal
hom of 𝒪_X-modules, and the chapter now records a concrete, individually-formalizable
build path (Decision 1) plus the Decision-3 fallback, rather than pretending the object
is constructible today. The associator's transitive dependence on the unproved
whiskering obligation, and the joint deferral of both re-routes onto morphism-level
descent, are now documented in-chapter.
