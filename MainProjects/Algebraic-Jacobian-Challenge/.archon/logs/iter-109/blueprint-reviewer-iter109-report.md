# Blueprint Review Report

## Slug
iter109

## Iteration
109 (Archon canonical)

## Top-level summaries

### Incomplete parts

- `Picard_LineBundle.tex` / Status note (Phase C1) at L17–27: cites the wrong post-C1 target. It says C1 replaces the body by `MonoidalCategory.Invertible` applied to `X.Modules`. Per the directive (and per Mathlib's `CommRing.Pic R := Shrink (Skeleton (SemimoduleCat R))ˣ`), the canonical idiom is `(Shrink (Skeleton X.Modules))ˣ` via `CategoryTheory.Skeleton.instCommMonoid [BraidedCategory C]`. Iter-109 C1 will land the corrected body; the chapter must describe the actual target.
- `Modules_Monoidal.tex` / Remark "Status of $W.\mathrm{IsMonoidal}$ and the stalks-level argument" at L59–61: contains the sentence "it does \emph{not} block downstream consumers, which use $\mathrm{MonoidalCategory}\,X.\mathrm{Modules}$ directly rather than $W.\mathrm{IsMonoidal}$ as a hypothesis." This is correct only *pre*-C1. Post-C1, every Lean term referencing `LineBundle X`, `Pic X`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, `Jacobian` instances, or `AbelJacobi` transitively depends on `instIsMonoidal_W`. The honest-disclosure paragraph mirroring the `nonempty_jacobianWitness` one is missing entirely.
- `Picard_Functor.tex` / Forward-compatibility note at L75–77: discloses the LineBundle approximation issue but says nothing about the new `SheafOfModules.pullback_tensorObj` deferred sorry that iter-109's "default option (c)" for `Pic.pullback` will introduce. Once C1 lands, `Pic.pullback` (Theorem~\ref{thm:Scheme_Pic_pullback}) will transitively depend on this sorry; the relative-Picard prose must acknowledge it.
- `Cohomology_MayerVietoris.tex` / Remark `rem:basicOpenCover_step2_status` at L1198: closing sentence enumerates the Mathlib-gap list as the older 3-tuple `(instIsMonoidal_W, h_exact, nonempty_jacobianWitness)`. Per the iter-108 STRATEGY end-state framing, the project-wide list is 5 named gaps + 1 budget-deferral. Either the remark must list all 5 (the new ones being `SheafOfModules.pullback_tensorObj` and `lem:sheafOfModules_exact_iff_stalkwise` — see also Differentials.tex L93 / L107), or it must point to a single canonical enumeration and not state the list inline.

### Proofs lacking detail

- `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 2 proof body at L1166–1178: the recipe enumerates (i) Image-Finset bridge, (ii) Restriction-of-section identity, (iii) Per-coord `IsLocalization.Away`, (iv) Finite-product localization lift. The status remark immediately below (`rem:basicOpenCover_step2_status` at L1196) re-labels these as "(i) and (ii)" = inclusion $V_x\subseteq U$ + restriction-of-section identity, and "(iii)" = image-Finset bridge + per-coord `IsLocalization.Away`. The numberings are inconsistent; downstream provers cannot reliably tell which Mathlib piece corresponds to which substep. The recipe's ordering should be canonical and the remark should follow it.
- `Cohomology_MayerVietoris.tex` / `rem:basicOpenCover_step2_status` at L1196: substep~(iv) cites `IsLocalizedModule.pi` and the algebra-map adapter, but the Lean DEFERRED block at `BasicOpenCech.lean:1846` (per the directive) names `IsLocalizedModule.prodMap` as a key piece of the missing transport. The blueprint remark should either include `prodMap` or explicitly note that `pi` is the bundled API and `prodMap` is the binary helper underneath. Provers using the remark as a roadmap will miss the binary primitive otherwise.
- `Picard_LineBundle.tex` / `\thm:Scheme_Pic_pullback` proof at L65–69: the post-C1 incarnation of this theorem needs the iso `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`. The proof body currently says "pull-back commutes with tensor product" without naming the named-deferred sorry that will carry this in Lean. Sufficient for pre-C1 prose; insufficient as a roadmap for the post-C1 prover round.

### Lean difficulty quality

- `Picard_LineBundle.tex` / `\lean{AlgebraicGeometry.Scheme.LineBundle}`: the *hint name* is correct, but the prose at L20–22 ("`CommRing.Pic(Γ(X, ⊤))`") is the pre-C1 body. After iter-109 the body becomes `(Shrink (Skeleton X.Modules))ˣ`. A prover formalising downstream API against this hint without reading the chapter would receive a misleading definitional view; the chapter prose at L20–27 must be re-aligned with the post-C1 body the same iter it lands.
- `Picard_LineBundle.tex` / `\lean{AlgebraicGeometry.Scheme.Pic.pullback}` at L57: as noted in "Proofs lacking detail", the hint will be load-bearing post-C1 but the prose does not yet name the `SheafOfModules.pullback_tensorObj` deferred sorry that it depends on. Provers consuming the hint will not see the dependency.
- `Modules_Monoidal.tex` / `\lean{AlgebraicGeometry.Scheme.Modules.instMonoidalCategory}` at L36: a prover would correctly read this as the C0 monoidal-instance target. The chapter does not flag that, after C1, the *internal* witness `instIsMonoidal_W` (Modules/Monoidal.lean L173) becomes a load-bearing sorry under this instance. The hint quality is "fine" (the named target exists); the surrounding prose under-describes the post-C1 fan-out.

### Multi-route coverage

Strategy (per directive) is single-route this iter — the C1 promotion commits to the analogist's default option (c) for `Pic.pullback`. No alternative routes are open; PASS by construction.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Albanese-route prose is consistent with Jacobian.tex's `\thm:nonempty_jacobianWitness` framing.
  - `\uses{}` cross-references all resolve (def:Jacobian, def:IsAlbanese, thm:nonempty_jacobianWitness, thm:IsAlbanese_unique).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - L1196 substep numbering in `rem:basicOpenCover_step2_status` inconsistent with the recipe's at L1167–1176. Recipe: (i) image-Finset bridge, (ii) restriction-of-section identity, (iii) per-coord `IsLocalization.Away`, (iv) finite-product localization lift. Remark inverts these — calls "(i) and (ii)" the inclusion+restriction-of-section pair and "(iii)" the image-Finset bridge+`IsLocalization.Away`.
  - L1198 remark omits `IsLocalizedModule.prodMap` even though the Lean DEFERRED comment at BasicOpenCech.lean:1846 (per directive) cites it as load-bearing.
  - L1198 closing sentence enumerates the Mathlib-gap list as the older 3-tuple `(instIsMonoidal_W, h_exact, nonempty_jacobianWitness)`; per iter-108 STRATEGY end-state the list is now 5 named + 1 budget-deferral.
  - Status block at L1205 "Status (iter-108 / Archon canonical iter-108)" — accurate snapshot of the six labelled transient sorries; this paragraph is the most up-to-date in the chapter.
  - § "Use in the project" at L1201–1206 expanded inline (iter-108 blueprint-writer mv-step2 dispatch). Internally consistent with the chain `IsAffineHModuleVanishing → Phase A step 6 → genus`.
  - The four Mathlib API pieces in Step 2's recipe at L1167–1176 (image-Finset bridge, restriction-of-section identity, per-coord `IsLocalization.Away`, finite-product localization lift) land correctly — modulo the numbering inconsistency flagged above.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem `thm:HasSheafCompose_forget` with a clean prover-grade proof sketch and `\lean{...}` hint.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three Phase~A items packaged cleanly; cross-refs to `thm:HasSheafCompose_forget` resolve.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long but well-organised. All `\lean{...}` hints carry consistent prose. Producer chain `IsHModuleHomFinite_toModuleKSheaf` is internally consistent.
  - § "Foundational parameterised Čech infrastructure" + "Čech-side acyclicity carrier" feed Cohomology_MayerVietoris.tex coherently.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-085/086/087 NOTE comments at L93 and L98–104 honestly describe the deferral of stalkwise route (parallel to `instIsMonoidal_W`). Section-wise+sheafification alternative also disclosed as blocked.
  - `lem:sheafOfModules_exact_iff_stalkwise` (L105–108) has no `\lean{...}` (correct — no Lean object exists after iter-085 revert).
  - Two formatting artifacts: blank line between `\begin{theorem}` and `\leanok` at L20–22 and L137–141. Cosmetic, not blocking.
  - The Lean-side issue flagged by lean-auditor-iter108 ("Differentials.lean:27 stale status header") is a `.lean` file issue, not a blueprint-side issue; the chapter prose itself is up-to-date.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition cleanly references `def:Scheme_HModule` and `def:Scheme_toModuleKSheaf`.
  - "Mathlib gap" and "User authorisation of noncomputable" sections record the right deferral language.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:nonempty_jacobianWitness` correctly bundles the genus-0 rigidity content into a single working-hypothesis sorry. Both Albanese routes (Pic-scheme + symmetric-power) are discussed.
  - Four protected Jacobian instances all marked with `\lean{...}` and `\uses{def:Jacobian}` cross-refs.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - L59–61 "Status of $W.\mathrm{IsMonoidal}$" remark says "does not block downstream consumers". Post-C1 this is false: `instIsMonoidal_W` becomes load-bearing for LineBundle, Pic, Pic.pullback, PicardFunctor, PicardFunctorAb, Jacobian instances, AbelJacobi. Honest-disclosure paragraph (mirroring `nonempty_jacobianWitness`'s) is missing.
  - L72 second paragraph closes with "the refinement is the content of Phase~C step~C1 (see STRATEGY.md)". After iter-109 C1 lands this prose is stale — needs to switch tense.
  - L93–96 "Use in the project" lists steps C1/C2/C3 — the C1 description ("redefining $\mathrm{LineBundle}\,X$ as the type of invertible $\mathcal O_X$-modules") uses the same wrong target as Picard_LineBundle.tex. Should be the `Shrink ∘ Skeleton` idiom.
  - L100 "Formalization status" still describes Monoidal.lean as the "active target of Phase~C step~C0" — after iter-109 step~C0 is dormant-but-load-bearing, not "active". Needs to switch state.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - L75–77 Forward-compatibility note discloses the LineBundle approximation issue, but does NOT mention the new `SheafOfModules.pullback_tensorObj` named-deferred sorry that iter-109's "default option (c)" for `Pic.pullback` will introduce. The relative-Picard chapter is the natural home for this disclosure (since `def:Pic_functor` consumes `thm:Scheme_Pic_pullback`).
  - L43 step-C2 description "re-derive `Pic.pullback`, `PicardFunctor`, and the étale sheafification against the refined `LineBundle`" — the prose currently says "re-derive", suggesting the work is in step C2; iter-109 lands the `pullback_tensorObj` sorry as part of C1, so the step-decomposition prose should be re-aligned.
  - Theorem `thm:Pic_representable` correctly held back as a `sorry`; the proof sketch is honest about the FGA-scale deferral.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - This chapter sits downstream of Picard_Functor.tex and inherits its issues; it does not introduce new wrong-target statements of its own.
  - The chapter does not need its own disclosure paragraph if Picard_Functor.tex carries the upstream `SheafOfModules.pullback_tensorObj` mention — the cross-reference at L23 ("functoriality \dots defined in Chapter~\ref{chap:Picard_Functor}") chains through.
  - Mark as `correct: partial` defensively, downgraded to "follow Picard_Functor.tex": no independent fix needed if upstream chapter is repaired.
  - L66 "The only remaining gymnastic is universe-pinning" is reassuringly specific and correct.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **L17–27 Status note (Phase C1)** is the central must-fix-this-iter item. Cites `MonoidalCategory.Invertible (X.Modules)` as the C1 target; per directive the canonical idiom is `(Shrink (Skeleton X.Modules))ˣ`. After iter-109's C1 refactor lands the prose at L17–27 is factually wrong about the actual Lean body.
  - **Theorem `thm:Scheme_Pic_pullback` proof** at L65–69 does not name the new `SheafOfModules.pullback_tensorObj` deferred sorry that the post-C1 body relies on.
  - **`% NOTE:` comments** at L35 and L53 correctly disclaim the pre-C1 `\leanok` markers; after C1 these need updating.
  - Section "Mathlib gap" at L82–99 is internally consistent and does not over-promise.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single self-contained theorem, clean proof sketch, all Mathlib ingredients enumerated. Highest-leverage standalone target.

## Cross-chapter notes

- **Wrong-target-language reverberates.** Picard_LineBundle.tex L27, Modules_Monoidal.tex L72 and L93–96 all cite the same incorrect post-C1 target (`MonoidalCategory.Invertible (X.Modules)` instead of `(Shrink (Skeleton X.Modules))ˣ`). A single fix in `Picard_LineBundle.tex` will not be sufficient; the prose in `Modules_Monoidal.tex` must be aligned in the same edit pass.
- **`instIsMonoidal_W` load-bearing transition.** Modules_Monoidal.tex L60 says the gap-fill "does not block downstream consumers". This sentence will become factually wrong post-C1, when `instIsMonoidal_W` becomes load-bearing for the entire Pic-and-down arc (LineBundle, Pic, Pic.pullback, PicardFunctor, PicardFunctorAb, Jacobian instances, AbelJacobi). The honest-disclosure paragraph that exists for `\thm:nonempty_jacobianWitness` (Jacobian.tex L116) is the model to mirror here.
- **`SheafOfModules.pullback_tensorObj` introduction.** Iter-109 introduces a new named-deferred sorry for `Pic.pullback`'s "(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N". The natural homes for the disclosure are Picard_LineBundle.tex (because `Pic.pullback` is defined there) and Picard_Functor.tex (because the relative Picard functor inherits the issue). Neither chapter currently mentions this. The post-iter-108 STRATEGY end-state framing 5+1 explicitly includes this sorry; the chapter prose currently does not.
- **3-vs-5 Mathlib-gap-list framing.** Cohomology_MayerVietoris.tex L1198 enumerates the project-wide Mathlib-gap list as `(instIsMonoidal_W, h_exact, nonempty_jacobianWitness)` — the older 3-tuple. The iter-108 STRATEGY update settled on 5 named + 1 budget-deferral. Either L1198 must extend the list (adding `SheafOfModules.pullback_tensorObj` and `lem:sheafOfModules_exact_iff_stalkwise`) or it must defer to a canonical enumeration (e.g. STRATEGY.md / Modules_Monoidal.tex L93–96 once updated) and avoid inlining a stale list.
- **Step 2 substep ordering.** Cohomology_MayerVietoris.tex's Step 2 recipe (L1167–1176) and the status remark (L1196) use inconsistent numbering for the same 4 Mathlib API pieces — the recipe and remark must align.

## Strategy-modifying findings (if any)

None. The C1 promotion strategy itself (per directive) is sound; the chapters' deviations from it are factual-update fixes inside the existing strategy.

## Severity summary

- **must-fix-this-iter** — chapters with `complete: partial | false` OR `correct: partial | false`:
  1. `Picard_LineBundle.tex` (partial × partial). The iter-109 C1 refactor lands the actual Lean body; the Status note at L17–27 and the proof sketch of `\thm:Scheme_Pic_pullback` at L65–69 must be re-aligned with the `(Shrink (Skeleton X.Modules))ˣ` target and must mention the new `SheafOfModules.pullback_tensorObj` deferred sorry. **Blueprint-writer dispatch this iter.**
  2. `Modules_Monoidal.tex` (partial × partial). Add the honest-disclosure paragraph that `instIsMonoidal_W` becomes load-bearing post-C1 (mirror the `\thm:nonempty_jacobianWitness` shape). Update L72, L93–96, L100 prose for the new post-C1 reality. **Blueprint-writer dispatch this iter.**
  3. `Picard_Functor.tex` (partial × partial). Extend the Forward-compatibility note at L75–77 to mention the new `SheafOfModules.pullback_tensorObj` sorry. Re-align the step-C2 description at L43 with iter-109's actual scope. **Blueprint-writer dispatch this iter.**
  4. `Cohomology_MayerVietoris.tex` (partial × partial). Fix the substep numbering inconsistency at L1196 (canonicalize on the recipe's (i)/(ii)/(iii)/(iv) ordering at L1167–1176), add `IsLocalizedModule.prodMap` to the remark, and update the 3-tuple Mathlib-gap-list enumeration in the remark closing at L1198. **Blueprint-writer dispatch this iter.**
  5. `Picard_FunctorAb.tex` (true × partial). Defensive flag — only requires action if upstream `Picard_Functor.tex` fix is not enough. Likely no independent edit needed.

- **soon** — none. All flagged findings are tied to the iter-109 C1 promotion landing this iter; deferring them risks downstream prover work against stale prose.

- **informational**:
  - Differentials.tex L20–22 and L137–141 have blank lines between `\begin{theorem}` and `\leanok`. Cosmetic; ignore unless the writer touches the file for other reasons.
  - The Lean-side carry-over items from iter-108 (LineBundle wrong-def excuse-prose, Functor.representable excuse-prose, instIsMonoidal_W excuse-prose, Differentials.lean:27 stale status header, BasicOpenCech.lean:17 stale sorry-count header, BasicOpenCech.lean:1846 DEFERRED invented-name annotations) live in `.lean` files and are out of scope for the blueprint-reviewer. The blueprint prose currently does not contradict the planned Lean-side fixes — it reinforces them where the chapters comment on the same gaps.

**Overall verdict**: Four chapters (`Picard_LineBundle.tex`, `Modules_Monoidal.tex`, `Picard_Functor.tex`, `Cohomology_MayerVietoris.tex`) require a blueprint-writer dispatch this iter before any prover round on the C1 promotion or its downstream consumers can be authorised; the rest of the blueprint is in good shape.
