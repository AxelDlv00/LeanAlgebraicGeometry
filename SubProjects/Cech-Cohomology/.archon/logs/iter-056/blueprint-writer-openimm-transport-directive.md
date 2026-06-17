# Blueprint-writer directive — fix the must-fix proof-detail gap in `lem:open_immersion_pushforward_comp`

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter; it
`% archon:covers` both `OpenImmersionPushforward.lean` and `CechSectionIdentification.lean`).

## Why you are dispatched
The iter-056 blueprint-reviewer flagged this chapter `complete: partial` with ONE must-fix that
gates the active prover route `OpenImmersionPushforward.lean`. The proof of
`lem:open_immersion_pushforward_comp` (statement at L7942, proof at L7987–8074) describes
"Serre vanishing for a general affine open" (Proof detail (2), L8057–8063) only in prose — it says
"one transports the vanishing along the canonical isomorphism j⁻¹(V) ≅ Spec Γ(j⁻¹V) using the
naturality of absolute cohomology" — but provides NO Lean anchor, no auxiliary lemma, and no
`\uses{}` edge for the transport. The prover cannot bridge this prose to Lean code.

The CHOSEN route (planner decision iter-056) is the **transport-along-isoSpec** reduction: the
general affine open `j⁻¹(V)` is itself an affine SCHEME (because `j` is an affine morphism — the
done `isAffineHom_of_affine_separated`), so `H^q(j⁻¹V, H)` is computed on a WHOLE affine scheme and
equals the ⊤-case `affine_serre_vanishing` over `Spec Γ(j⁻¹V)`, transported across the canonical
iso `j⁻¹V ≅ Spec Γ(j⁻¹V)`. **We do NOT build a general-affine-open `BasisCovSystem`** (that heavier
infra is explicitly rejected). Your job is to make this transport route concrete at the
blueprint level so a prover can follow it.

## Tasks (all in the named chapter)

### Task 1 — add an auxiliary lemma block `lem:rightDerivedNatIso`
A prover already built and proved (axiom-clean) the Lean lemma
`AlgebraicGeometry.rightDerivedNatIso` in `OpenImmersionPushforward.lean`: *a natural isomorphism
of additive functors `F ≅ G` induces an isomorphism of their n-th right-derived functors*
`(F.rightDerived n) ≅ (G.rightDerived n)`. Add a compact `\begin{lemma}…\end{lemma}` block:
- `\label{lem:rightDerivedNatIso}`
- `\lean{AlgebraicGeometry.rightDerivedNatIso}`
- `\uses{}` — it relies only on Mathlib's `NatTrans.rightDerived` functoriality (`_comp`/`_id`);
  no project deps. Leave `\uses{}` empty or omit.
- Statement in project notation: for additive functors `F, G : 𝒜 ⥤ ℬ` on abelian `𝒜` with enough
  injectives and a natural iso `F ≅ G`, there is a natural iso `F.rightDerived n ≅ G.rightDerived n`.
- One-line informal proof: right-derived functors are functorial in the functor argument via
  `NatTrans.rightDerived`; apply to the iso's hom/inv and use `_comp`/`_id` to get mutually inverse
  derived maps.
This is Archon-original infrastructure (no external source) — omit the SOURCE lines.

### Task 2 — make Proof detail (2) concrete (the must-fix)
Rewrite Proof detail (2) "Serre vanishing for a general affine open" (currently L8057–8063) so it
names the EXACT Lean mechanism and decomposes the transport into named sub-steps. It must:
- State that `j` is an affine morphism via `AlgebraicGeometry.isAffineHom_of_affine_separated`
  (already done), hence `j⁻¹(V)` (resp. `U ∩ f⁻¹V`) is an affine scheme.
- Name `AlgebraicGeometry.IsAffine.isoSpec` (verify the exact Lean name with the analogist's report
  `task_results/mathlib-analogist-change-of-scheme-cohomology.md` if it has landed; otherwise write
  `AlgebraicGeometry.IsAffine.isoSpec` / `Scheme.isoSpec` and flag it `% NOTE: confirm Lean name`)
  as the canonical scheme isomorphism `j⁻¹V ≅ Spec Γ(j⁻¹V, 𝒪)`.
- Explain the transport chain: the absolute cohomology `Ext^q(jShriekOU(j⁻¹V), H)` is carried across
  this scheme iso to `Ext^q(jShriekOU(⊤ on Spec Γ(j⁻¹V)), H')` (the ⊤-instantiation), which is
  `affine_serre_vanishing` and vanishes for `q ≥ 1`. The vehicle for the derived-functor transport
  is `lem:rightDerivedNatIso` (the functor iso being the one the scheme iso induces on the
  sections/coyoneda functors via `sectionsFunctorCorepIso`).
- Add a `\uses{lem:rightDerivedNatIso, lem:affine_serre_vanishing}` edge to the proof block's
  `\uses{}` list (line 8137/8171/8188 region carries the consumers; the inner proof `\uses` is at
  L7988 — ADD `lem:rightDerivedNatIso` there).
- If, while writing, you find the transport genuinely needs an intermediate lemma not yet present
  (e.g. "a scheme iso induces an equivalence of module categories compatible with `jShriekOU`"),
  add a SECOND compact aux lemma block for it with a `\lean{…TODO…}` placeholder pin and an
  informal proof sketch, and `\uses`-link it. Do NOT invent a Lean name that does not exist —
  use a `…TODO…` pin so it reads as a build target, not a fill-sorry target.

### Task 3 — add blueprint entries for the isolated `lean_aux` helpers (coverage debt)
These prover-created, already-proved Lean decls have NO blueprint block (the reviewer listed them).
Add a compact block (statement + `\label` + `\lean{}` + accurate `\uses{}` + one-line informal
proof) for each, placed under the open-immersion-pushforward / Sub-brick-A sections as the reviewer
indicated:
- `AlgebraicGeometry.sectionsFunctorCorepIso` — `sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))`
  (Γ(V,−) corepresented by `jShriekOU V`). `\uses{}` the absolute-cohomology corepresentability
  (`jShriekOU_homEquiv`).
- `AlgebraicGeometry.rightDerivedNatIso` — covered by Task 1 (do not duplicate).
- `AlgebraicGeometry.sectionsFunctor_additive` (instance) — `(sectionsFunctor V).Additive`.
- `AlgebraicGeometry.toPresheafOfModules_additive` (instance) — `(toPresheafOfModules X).Additive`.
- `AlgebraicGeometry.isZero_homology_of_iso_homotopy_id_zero` (in `CechAugmentedResolution.lean`):
  for `[CategoryWithHomology C]`, `(D ≅ D') → Homotopy (𝟙 D') 0 → IsZero (D.homology p)`. Place it
  under the Sub-brick A / `lem:cech_augmented_resolution` section near `lem:isZero_homology_of_homotopy_id_zero`;
  `\uses{lem:isZero_homology_of_homotopy_id_zero}`. It is the consumer glue for Step 3(d).
(`jShriekOU_homEquiv_nat` is `private` — no blueprint node needed; skip it.)
These are Archon-original — omit SOURCE lines; trivial one-line informal proofs are fine and mandatory.

### Task 4 — delete stale prose
At L3244–3248 (inside `lem:affine_serre_vanishing`'s body) there is a STALE paragraph reading
"it is currently formalized in the reduced `_of_tildeVanishing` form pending the residual" — the
lemma is now fully proved and axiom-clean. A `% NOTE:` at L3217–3223 already flags it. DELETE the
stale paragraph (and the now-redundant NOTE if it only points at the stale text).

### Task 5 — clarify the misleading `\uses` prose
In `lem:cechSection_contractible` the proof prose references the `dep*` combinatorial engine "of
Lemma~\ref{lem:cech_acyclic_affine}". This is a Lean-LOCATION pointer (the `dep*` decls are bundled
into that lemma's `\lean{}`), NOT a math dependency on the standard-cover Čech vanishing conclusion.
Add a short parenthetical making this explicit, e.g.: "(here `lem:cech_acyclic_affine` is cited only
as the Lean home of the `dep*` engine declarations — its Čech-vanishing conclusion is NOT a
mathematical dependency)."

## Hard constraints
- Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (+ `references/**` only if
  you must spawn a reference-retriever — unlikely; the Stacks quote is already present).
- Do NOT add or remove `\leanok` (deterministic sync owns it). You MAY use `\lean{}` and `\uses{}`.
- Keep every block's prose mathematical, textbook-level, in project notation.
- Citation discipline: the relevant `% SOURCE`/`% SOURCE QUOTE PROOF` for the relative-affine
  vanishing are ALREADY present (L7951–7986); do not fabricate new ones. The new aux lemmas are
  Archon-original (no SOURCE lines).

## Out of scope
Do NOT touch the Sub-brick A stub statements, the P3/P3b/01I8/02KG sections, or any other chapter.
Do NOT re-architect the proof of `lem:open_immersion_pushforward_comp` — only make detail (2)
concrete and add the missing aux/coverage blocks.
