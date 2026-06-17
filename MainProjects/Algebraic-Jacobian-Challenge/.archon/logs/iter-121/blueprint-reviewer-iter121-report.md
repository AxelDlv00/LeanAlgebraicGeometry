# Blueprint Review Report

## Slug
iter121

## Iteration
121

## Top-level summaries

### Incomplete parts
- `Differentials.tex` / **broken refs**: three `\ref{sec:bridge-out-of-scope}` calls (lines 30, 41, 46) point to a label that no longer exists — the new bridge section uses `\label{sec:bridge}` (line 109). Renders as "??" in PDF. Must fix.
- `Differentials.tex` / **LaTeX syntax error**: line 199 closes with `\end{remark>` instead of `\end{remark}`. This breaks the LaTeX compile of `rem:bridge_mathlib_pr` outright (mismatched delimiter). Must fix.
- `Modules_Monoidal.tex` / `thm:Modules_BraidedCategoryPresheaf` and `thm:Modules_BraidedCategory` (lines 78, 87): the formalization-status section (lines 144–145) reports these instances as closed, but neither theorem statement carries `\leanok`. Soon — informational, not gating.

### Proofs lacking detail
- `Differentials.tex` / `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE` (line 126): the M1.b sub-step in the body refers to a *"cofinality-of-directed-colimit lemma that may need to be supplied as part of M1.b"* with no concrete proof. The blueprint flags this as the "genuine Mathlib contribution" of the milestone, but offers no proof skeleton at the cofinality level (e.g., does not name `Filtered.colimit_eq_iff_pre`, `DirectedSystem.localization_at_directed_colimit`, or any analogous Mathlib backbone). A prover starting on M1.b will hit this and need a writer-pass for that step.
- `Differentials.tex` / `lem:appLE_isLocalization` (line 160): the proof restates the cofinality argument from M1.b but again leaves the cofinality lemma as "may need to be supplied". This is the same gap re-stated; needs a concrete Lean-shape proposal before a prover round.
- `Jacobian.tex` / sub-step **C.2** (rigidity for `ℙ¹_k → A`, line 319): the reduction from the project's `GrpObj.eq_of_eqOnOpen` (Rigidity.lean, full chapter) to the specialised `Hom(ℙ¹_k, A) = A(k)` is in **one sentence** — "this fibre is all of ℙ¹_k over the identity of A". For M2.a, the prover needs more: which non-empty open of `ℙ¹_k` agrees on the identity, how the rigidity hypothesis (smooth proper geometrically irreducible source) is verified for `ℙ¹_k`, and how the conclusion `f = const_{η_A}` is then upgraded to a bijection with `A(k)`. The chapter is partially-complete on M2.a.
- `Jacobian.tex` / sub-step **C.1** (line 317): "uses h⁰(C, O(P)) = 2 (Riemann–Roch) to produce a degree-1 morphism C → ℙ¹_k, which is then an isomorphism by degree-and-dimension." This is acceptable as a deferred description (M2.c is gated on Riemann–Roch and not in the active prover queue), but it is too terse to start work on; flagged as informational since the directive labels M2.c as gated.

### Lean difficulty quality
- `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.kaehler_localization_subsingleton}` (line 167): the statement is "Let A → L be a localization at a multiplicative subset M ⊆ A. Then Ω[L/A] is subsingleton." The Lean target signature is under-specified — for the prover, the question is whether the inputs are `(A L : Type*) [CommRing A] [CommRing L] [Algebra A L] (M : Submonoid A) [IsLocalization M L]` (standard Mathlib `IsLocalization` shape) or one of the alternative bundlings. The prose chooses neither. Recommended: add a `\begin{equation}` snippet of the intended Lean signature, or note "use the `IsLocalization M L` typeclass shape of `Mathlib.RingTheory.Localization.Basic`". Same applies to `\lean{AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso}` (line 178).
- `Differentials.tex` / proof of `thm:smooth_locally_free_omega` Step 1 (line 67): the proof prose cites `AlgebraicGeometry.smoothOfRelativeDimension_iff` as `[verified]`, but the corresponding Mathlib `b80f227` name is `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` (with the `Is` prefix). The actual Lean file `AlgebraicJacobian/Differentials.lean:101` uses the project-defined `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`, not the `mk_iff`-derived name claimed by the blueprint. Mathlib-name drift; the theorem closes in Lean regardless, so this is **informational**, not a must-fix.
- `Differentials.tex` / proof of `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE` M1.b sub-step (line 137): cites `IsAffineOpen.basicOpen_isLocalization`, but the real Mathlib name (verified via `lean_leansearch`) is `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` — the prose has the suffix order inverted. The same lemma is then re-cited *correctly* at line 162 inside `lem:appLE_isLocalization`'s proof. Name-inconsistency within a single chapter; please regularise.

### Multi-route coverage

- **Route M1 (bridge presheaf ↔ algebra-Kähler form)**: **PARTIAL**. Covered by the new section `\sec{Bridge: presheaf form ↔ algebra-Kähler form on an affine chart (milestone M1)}` in `Differentials.tex` (lines 108–199). Theorem `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE` plus three auxiliary lemmas. The decomposition is sound at the **strategy** level (M1.a / M1.b / M1.c / M1.d / M1.e all named), but the M1.b cofinality lemma — explicitly named the "heart of the milestone" — lacks a concrete proof skeleton. A prover starting on M1 will need a writer pass on M1.b before progress is possible; M1.a, M1.c, M1.d, M1.e have adequate detail.
- **Route M2 — Genus-0 witness via rigidity (Route C)**: **PARTIAL**. Covered in `Jacobian.tex § Existence of an Albanese variety` sub-cases C.1–C.3 (lines 313–329). M2.b (trivial witness) is in adequate shape. M2.a (rigidity specialisation) is one sentence — needs writer expansion before the prover starts. M2.c (`C ≅ ℙ¹_k`) is correctly disclosed as gated on Riemann–Roch; not a blocker this iter.
- **Route M3 — General-genus witness (Routes A and B)**: **PASS** at the strategic-decomposition level. `Jacobian.tex § Route A` (lines 255–284) covers A.1–A.4; `Route B` (lines 286–311) covers B.1–B.3. Each sub-step is paired with a "Mathlib status" inventory naming the missing infrastructure. Appropriate for a deferred multi-month roadmap; no writer pass needed this iter.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\lean{...}` hints align with the protected signatures named in `references/challenge.lean` (verified by directive).
  - Classical-description remarks (Pic-scheme route) correctly disclose that the Lean side closes by projection from the Albanese predicate, not by replaying the classical proof.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Per directive, historical iter-NN scaffolding remarks are intentional; not re-flagged.
  - All `\uses{...}` cross-refs in this chapter resolve to labels inside this chapter or `Cohomology_StructureSheafModuleK.tex`.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Per directive, historical iter-NN scaffolding remarks are intentional; not re-flagged.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **LaTeX error** at line 199: `\end{remark>` should be `\end{remark}`. Will break LaTeX compilation of the chapter.
  - **Broken `\ref{...}`** at lines 30, 41, 46: `\ref{sec:bridge-out-of-scope}` points at a label that does not exist; the new section uses `\label{sec:bridge}`. Three call-sites; renders "??" in PDF.
  - **Name drift** at line 137: `IsAffineOpen.basicOpen_isLocalization` should be `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` (verified against Mathlib `b80f227`). Same lemma cited correctly at line 162; please regularise.
  - **Name drift** at line 67: `smoothOfRelativeDimension_iff` cited as `[verified]`, but real Mathlib name is `isSmoothOfRelativeDimension_iff` and the actual Lean proof uses `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`. Cosmetic; the closed theorem typechecks.
  - **M1.b proof gap**: the cofinality lemma at the heart of M1 has no proof skeleton; just a deferral note. Needs a writer pass before a prover round on M1.b.
  - **Suspicious `\uses{...}`** at line 168: `lem:kaehler_localization_subsingleton` declares `\uses{lem:appLE_isLocalization}`, but the algebraic lemma "Ω[L/A] = 0 for L a localization of A" is logically *independent* of `appLE_isLocalization`. The dependency direction is wrong; the lemma should `\uses{def:relative_kaehler_presheaf}` (or nothing) instead.
  - `def:Modules_Invertible` placement: defined in `Modules_Monoidal.tex` line 105; consumed here implicitly. Not a defect.
  - The converse-out-of-scope section is correctly disclosed (counterexample `Spec k → Spec k[t]` plus the `Subsingleton (H1Cotangent)` hypothesis from `IsStandardSmooth.of_basis_kaehlerDifferential`). Per directive, do not re-flag.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Sub-step **C.2 (rigidity)**: one-sentence reduction is too thin for the M2.a prover lane that the directive identifies as next. Needs writer expansion: name the open of `ℙ¹_k` used, verify the smooth-proper-geom-irreducible hypotheses on `ℙ¹_k`, sketch the upgrade from "constant" to the bijection `Hom(ℙ¹_k, A) = A(k)`.
  - Sub-step **C.1 (Brauer–Severi identification)**: short; correctly disclosed as gated on Riemann–Roch. Acceptable as deferred under M2.c.
  - **Route A / Route B**: per-sub-step Mathlib-gap inventories (A.1–A.4 and B.1–B.3) are appropriate for the multi-month M3 roadmap, no writer pass needed.
  - `nonempty_jacobianWitness` (the single project sorry) correctly bundles all three routes plus the genus-0 sub-case into one statement, with the witness's `JacobianWitness` carrier explained in `def:JacobianWitness` and `rem:JacobianWitness_quantifier_order`.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:Modules_BraidedCategoryPresheaf` (line 78) and `thm:Modules_BraidedCategory` (line 87) lack `\leanok` on their statement blocks even though §"Formalization status" (lines 144–145) reports both as closed registrations. Likely a `sync_leanok` blind-spot or pre-iter-NN slip; informational.
  - `def:Modules_Invertible` (line 105) has no `\lean{...}` hint, which is correct — it is conceptual; the formal target lives in the Skeleton-units form recorded in `Picard_LineBundle.tex`.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**: leaf chapter not on an active prover route this iter; audit not gating.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**: leaf chapter not on an active prover route this iter; audit not gating.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**: leaf chapter not on an active prover route this iter; audit not gating.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**: -

## Cross-chapter notes

- `Differentials.tex` line 162 cites `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` (the real Mathlib name); line 137 cites `IsAffineOpen.basicOpen_isLocalization` (a swapped-suffix variant that does not exist in Mathlib `b80f227`). Same lemma, two different names within the same chapter. Pick one (the correct one) and regularise.
- `Differentials.tex § sec:converse-out-of-scope` and the "Content out of autonomous-loop scope" tail (line 236 onwards) describe the unchanged trim from iter-117. The iter-121 pivot (drop "deferred" framing) is **not yet reflected** in this prose — the section still uses the phrase "out of autonomous-loop scope" four times. STRATEGY.md (line 22) drops this framing; the chapter has not been updated to match. Soon, not must-fix-this-iter, because the section describes converse-direction content that is genuinely a future M4 roadmap entry per STRATEGY.md line 198. Worth flagging for a later writer pass.
- `Differentials.tex` line 6 references `Section~\ref{sec:bridge}` correctly (the new bridge section); the same paragraph also refers to `Section~\ref{sec:converse-out-of-scope}`, which exists. So only the *three* `sec:bridge-out-of-scope` call-sites are broken; not a chapter-wide pattern.

## Strategy-modifying findings

None.

## Severity summary

- **must-fix-this-iter**:
  - `Differentials.tex` line 199 LaTeX syntax error `\end{remark>` — breaks `make blueprint` compile.
  - `Differentials.tex` three broken `\ref{sec:bridge-out-of-scope}` at lines 30, 41, 46 — visible "??" in PDF, silently corrupts the cross-reference graph; the directive lists Differentials as the M1 prover lane this iter, so the chapter is on an active prover route.
  - `Differentials.tex` chapter `complete: partial` (the M1.b cofinality lemma lacks a proof skeleton and is the explicit "heart of the milestone"). The HARD GATE rule applies: M1 prover dispatch should be **deferred** this iter pending a `blueprint-writer` pass that supplies the cofinality proof skeleton (cite the Mathlib backbone, e.g. `IsLocalization.lift_iff_of_finiteType`, `Localization.atUnits`, `Filtered.cocone_of_cofinal`, or whatever Mathlib piece the writer chooses) and corrects the broken refs / LaTeX error.
  - `Jacobian.tex` chapter `complete: partial` on sub-step C.2 (rigidity specialisation) — the directive identifies M2.a as a candidate next prover lane; per HARD GATE, a writer pass on `Jacobian.tex § C.2` is required before any M2.a prover dispatch.

- **soon**:
  - `Differentials.tex` line 137 vs 162 Mathlib-name inconsistency `IsAffineOpen.basicOpen_isLocalization` vs `IsAffineOpen.isLocalization_basicOpen`.
  - `Differentials.tex` line 168 incorrect `\uses{lem:appLE_isLocalization}` on the algebraically-independent `lem:kaehler_localization_subsingleton`.
  - `Differentials.tex § sec:converse-out-of-scope` still uses "out of autonomous-loop scope" language not aligned with iter-121 STRATEGY.md pivot.

- **informational**:
  - `Differentials.tex` line 67 `smoothOfRelativeDimension_iff` Mathlib-name drift (real name has `Is` prefix; project's own Lean code uses an entirely different lemma).
  - `Modules_Monoidal.tex` missing `\leanok` on `thm:Modules_BraidedCategoryPresheaf` / `thm:Modules_BraidedCategory`.
  - `Jacobian.tex` C.1 is terse but correctly disclosed as gated on Riemann–Roch (M2.c).

Overall verdict: the new `Differentials.tex § sec:bridge` section is a strong strategic-level decomposition but ships with one LaTeX syntax error, three broken `\ref{...}` call-sites, a missing proof skeleton at the M1.b cofinality lemma, and one wrong `\uses{...}` direction — the M1 prover lane should be deferred this iter pending a `blueprint-writer` pass on Differentials.tex; M2.a likewise needs a brief writer pass on `Jacobian.tex § C.2` before its prover round; routes M3 (Route A / Route B) are appropriately deferred at the strategy level and need no writer pass this iter.
