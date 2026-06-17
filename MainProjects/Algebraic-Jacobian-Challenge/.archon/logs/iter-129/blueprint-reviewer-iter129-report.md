# Blueprint Review Report

## Slug
iter129

## Iteration
129

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / sub-step (i.a) declaration block (Lemma `lem:GrpObj_lieAlgebra`): the prose says `\mathfrak g^{\vee} := \eta_G^* \Omega_{G/k}` is a finitely-generated free `k`-module, but provides **no rank-lemma bridge** between the iter-128 prover's concrete body construction (evaluate `relativeDifferentialsPresheaf G.hom` at the top open + `ModuleCat.extendScalars` along `Γ(G.left, ⊤) ⟶ k`) and the iter-129+ rank lemma `lem:GrpObj_lieAlgebra_finrank`. The rank lemma's stated proof (lines 123–126) consumes the standard "cotangent at a smooth point" presentation via `IsRegularLocalRing.cotangentSpace`, while the actual Lean body computes a quotient via tensor extension of scalars. The bridge — that `(ModuleCat.extendScalars ψ.hom).obj (Ω_{G/k}(⊤))` is canonically the cotangent space `𝔪_{η_G}/𝔪_{η_G}²` — is the load-bearing identification an iter-129+ prover needs, and the chapter does not preview it.

- `RigidityKbar.tex` / sub-step (i.a) `\lean{...}` hint pin: the iter-128 prover lane landed `lieAlgebra` with the hardcoded instance binder `[SmoothOfRelativeDimension 1 G.hom]` (see `AlgebraicJacobian/Cotangent/GrpObj.lean:88`). The chapter's lemma prose does NOT make the relative-dimension parameter `n` explicit at sub-step (i.a) (it only surfaces at the rank lemma, line 116); the `\lean{...}` hint on line 95 does NOT include a signature stub pinning `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`. Without a signature stub, the iter-128 hardcoding regression is not prevented for the iter-129 must-fix relax.

- `RigidityKbar.tex` / sub-step (i.a) declaration prose vs. status (lines 94–102): the lemma's stated mathematical content is "$\mathfrak g^{\vee} := \eta_G^* \Omega_{G/k}$ is finitely generated free over $k$"; the Lean encoding note (lines 102) authorizes either convention (dualise inside the declaration OR leave as $\mathfrak g^\vee$). The chapter does NOT pin which convention the iter-128 body chose — and so cannot enforce that the file's top docstring agrees with the body. The iter-128 review-phase auditors flagged this as a must-fix; the chapter's encoding note must be tightened to specify the body returns $\mathfrak g^\vee = \eta_G^* \Omega_{G/k}$ (not its dual), so the iter-129 docstring fix is unambiguous.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_lieAlgebra_finrank` proof (lines 123–126): one sentence, "The cotangent space at a smooth point of a scheme of relative dimension $n$ is an $n$-dimensional $k$-vector space; here the smooth point is the identity section…" The proof gives no decomposition into Mathlib closure pieces (no naming of `IsRegularLocalRing.cotangentSpace`, no specification of how `SmoothOfRelativeDimension n` connects to the cotangent-space dimension, no naming of the rank-of-dual lemma). For a `\notready` declaration on an active iter-129+ prover route, the proof sketch must name the load-bearing Mathlib lemmas (cf. the level of detail in `Differentials.tex` Theorem~`thm:smooth_locally_free_omega`'s proof, which names five specific Mathlib closure pieces). A prover dispatched to this rank lemma today would have to reverse-engineer the closure path.

- `RigidityKbar.tex` / `lem:GrpObj_mulRight_globalises` proof (lines 147–153): names the shear iso construction adequately but does not name the Mathlib piece for $\Omega_{(G \times_k G)/G} \cong \pr_{2}^{*}\,\Omega_{G/k}$ — the first-projection cotangent identification it consumes. Without this name, a prover starts from "the canonical first-projection-cotangent identification" with no Mathlib lemma to anchor to. (Sub-step (i.b) is iter-130+ work, so this is "soon", not blocking iter-129 if (i.a) work fires first.)

- `Jacobian.tex` § C.2.d (lines 332–348): the two proof routes ("via the dual abelian variety" and "via the cotangent bundle") are sketched at the textbook level but neither names Mathlib closure pieces. This is acceptable since the whole sub-step C.2.d is packaged into the named declaration `\thm{thm:rigidity_over_kbar}` whose own chapter (`RigidityKbar.tex`) decomposes the closure; the gap is only that `Jacobian.tex` could reference the shared pile (i)+(ii)+(iii) names rather than re-sketching the cotangent-bundle route. Informational, not blocking.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` (line 95): poor. The hint pins only the bare name — no signature stub. The iter-128 prover lane went off-spec on the `[SmoothOfRelativeDimension 1 G.hom]` binder; iter-129's relax must avoid the same trap. **Severity: must-fix-this-iter, since the corresponding `Cotangent/GrpObj.lean` is the iter-129 active prover route.**

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}` (line 113): adequate-with-caveat. The Lean target name is specified and the rank-lemma right-hand side is pinned to the explicit `n` from `[SmoothOfRelativeDimension n G.hom]` (per the iter-128 strategy-critic CHALLENGE retained in the encoding note at lines 119–120). However: it lacks an inline signature-stub on the `\lean{...}` line; a prover would have to read the encoding note prose 7 lines below the `\lean{...}` to discover the `[SmoothOfRelativeDimension n G.hom]` instance argument. Mid-grade hint; suggest adding a signature stub. (Not iter-129's active prover route — iter-129 may dispatch only to the relaxed `lieAlgebra` signature + docstring fix, not the rank lemma.)

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (line 130): adequate. The name encodes "shear-globalises-cotangent" semantically and the lemma prose specifies the natural iso shape; a prover has enough to formulate. The proof-sketch detail is the blocking item, not the hint.

- `Modules_Monoidal.tex` / `\lean{AlgebraicGeometry.Scheme.Modules.instMonoidalCategory}` and `\lean{AlgebraicGeometry.Scheme.Modules.instIsMonoidal_W}` (and 3 sibling Lean hints in Picard\_*.tex): poor — the named declarations live in `AlgebraicJacobian/Modules/Monoidal.lean` and `AlgebraicJacobian/Picard/{LineBundle,Functor,FunctorAb}.lean`, but **those files do not exist in the current Lean tree**. The hints point at phantom declarations. (Severity: must-fix-this-iter via the broader orphan-chapter finding below; the chapters themselves must be excised or revived.)

### Multi-route coverage

The directive specifies a **single route** (M2 closure via `rigidity_over_kbar` over `k` per the iter-127 commitment; piece (iv) Serre duality deferred). The fallback (over-`k̄` baseline + M2.c Galois descent) is documented as DROPPED in both `RigidityKbar.tex` § "Iter-127 over-k commitment" and `Jacobian.tex` § C.2.f.

- Route "M2 via `rigidity_over_kbar` over `k` + shared cotangent-vanishing pile (i)+(ii)+(iii)": **PARTIAL** — covered in `RigidityKbar.tex` (statement + decomposition + sub-step (i) sub-lemma decomposition) and `Jacobian.tex` § C.2 + § `sec:genusZeroWitness`; (ii) and (iii) of the pile have NO chapter content beyond a one-paragraph bullet in `RigidityKbar.tex` § `sec:RigidityKbar_shared_pile`. This is acceptable for iter-129 because the active prover route is sub-step (i.a) only, but pieces (ii) and (iii) WILL need their own decomposed chapters before any iter-131+ prover lane can target them (currently they have no chapter; the iter-129+ build order (i)→(ii)→(iii) means (ii) chapter authoring should be queued for iter-130 plan phase).

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three Lean targets (`Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`) exist in `AbelJacobi.lean`; chapter prose accurately describes the Albanese-projection construction.
  - Classical-description remarks are clearly demarcated as non-Lean.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Very large chapter (947 lines) but well-organised. Every `\lean{...}` hint references a declaration that exists in `MayerVietorisCore.lean` or `MayerVietorisCover.lean`.
  - `lem:Scheme_AffineCoverMVSquare_corners` (line 444) has no `\lean{...}` (it is a prose corner-identification remark superseded by the four individual `_X₁..._X₄` corner lemmas); this is intentional and not an issue.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: Single theorem, accurately described; Lean target exists.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: Three definitions+theorems, each accurately described; all Lean targets exist.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter (655 lines), substantial declaration density (Phase~A step 5 plus Serre-finiteness scaffolding); all reviewed `\lean{...}` hints point at declarations in `StructureSheafModuleK.lean`.
  - Section structure cleanly tracks the per-iter content of Phase~A.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Post-iter-126 excise is clearly disclosed; remaining declarations (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `smooth_locally_free_omega`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`) all exist in `Differentials.lean`.
  - Theorem `thm:smooth_locally_free_omega` proof sketch is a model of detail (names 5 specific Mathlib closure pieces) — this is the level of decomposition the `RigidityKbar.tex` rank lemma should aspire to.
  - Section `sec:converse-out-of-scope` (M4) is well-disclosed; explicit counterexample is sound.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: Single definition, Lean target exists in `Genus.lean`; Serre finiteness gap is clearly disclosed.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - All `\lean{...}` hints (`IsAlbanese`, `IsAlbanese.ofCurve`, `IsAlbanese.comp_ofCurve`, `IsAlbanese.exists_unique_ofCurve_comp`, `IsAlbanese.unique`, `Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`, `JacobianWitness`, `genusZeroWitness`, `nonempty_jacobianWitness`) match actual declarations in `Jacobian.lean`.
  - § C.2.a "Statement (over $\bar k$)" (line 322) and the introductory paragraph of § C.2 (line 319) retain over-$\bar k$ prose ("We state the rigidity result over the algebraic closure $\bar k$… The conclusion over $k$ follows by Galois descent"), inconsistent with the iter-127 over-k commitment that **eliminates** the Galois-descent step (§ C.2.f explicitly says "DROPPED iter-127"). The drift is internally inconsistent: § C.2.a posits an over-$\bar k$ framing whose only purpose was to feed a Galois descent that § C.2.f says is no longer performed. Per the directive, this is a known iter-128 soon-item; for iter-129 closure of `Cotangent/GrpObj.lean` it is non-blocking (the relevant declaration `rigidity_over_kbar` is at signature-already-`k`-agnostic), but the prose drift carries `correct: partial` and is worth fixing in a blueprint-writer pass that also handles the `RigidityKbar.tex` must-fix items.
  - `def:genusZeroWitness` proof sketch (lines 391–411) is adequately detailed for an iter-145+ prover lane: it names all seven witness fields, walks each construction (terminal-object underlying scheme, project-local `geometricallyIrreducible_id_Spec` helper, `genus C = 0` rewrite for `smoothGenus`, rigidity invocation for `isAlbaneseFor`, vacuity for `C(k) = ∅`), and pins the Lean target `AlgebraicGeometry.genusZeroWitness`. Detail level is comparable to `thm:smooth_locally_free_omega`. **No iter-129 blueprint-writer work needed on the genus-0 witness sketch.**

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: false
- **correct**: false
- **notes**:
  - **ORPHAN chapter.** Lean targets (`Scheme.Modules.tensorObj`, `Scheme.Modules.instMonoidalCategory`, `Scheme.Modules.instBraidedCategory`, `Scheme.Modules.instIsMonoidal_W`, etc.) live in `AlgebraicJacobian/Modules/Monoidal.lean`, which **does not exist in the current Lean tree** (confirmed by `ls AlgebraicJacobian/`). All `\leanok` markers on declarations in this chapter are stale and likely mis-classifying phantom targets as compiled.
  - The chapter's narrative (Phase~C step C0–C1, refactor to `LineBundle X := (Skeleton X.Modules)^×`) describes a strategic arc the project has eliminated under the iter-127 over-k commitment + Albanese-witness route. There is no in-tree consumer of `Modules.instMonoidalCategory`, `LineBundle`, `Pic`, `PicardFunctor`, or `instIsMonoidal_W`.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: false
- **correct**: false
- **notes**:
  - **ORPHAN chapter.** All `\lean{...}` hints (`PicardFunctor`, `PicardFunctor.representable`) reference declarations in `AlgebraicJacobian/Picard/Functor.lean`, which does not exist.
  - The "Post-C1 dependency note" (lines 78–89) explicitly references files that do not exist (`AlgebraicJacobian/Picard/LineBundle.lean:93,82`, `AlgebraicJacobian/Modules/Monoidal.lean:166`).
  - References Theorem `thm:Pic_representable` as the "bundled blocker for the four Jacobian.lean sorries", but the iter-127 strategy explicitly routes around Picard representability via the `JacobianWitness` + over-k rigidity arm.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: false
- **correct**: false
- **notes**:
  - **ORPHAN chapter.** Both Lean targets (`PicardFunctorAb`, `PicardFunctorAb.etaleSheafified`, `PicardFunctorAb_forget_obj`, `PicardFunctorAb.forgetCompare`) point at declarations in `AlgebraicJacobian/Picard/FunctorAb.lean`, which does not exist.
  - Same structural rot as `Picard_Functor.tex`; the C1/C2 narrative is orphaned by the iter-127 strategic shift.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: false
- **correct**: false
- **notes**:
  - **ORPHAN chapter.** All Lean targets (`Scheme.LineBundle`, `Scheme.instCommGroupLineBundle`, `Scheme.Pic.pullback`, `Scheme.Pic.pullback_id`, `Scheme.Pic.pullback_comp`, `Scheme.SheafOfModules.pullback_tensorObj`, `Scheme.SheafOfModules.pullback_oneIso`) point at declarations in `AlgebraicJacobian/Picard/LineBundle.lean`, which does not exist.
  - The chapter's "load-bearing transitive dependency on `instIsMonoidal_W`" prose (lines 24–25) cites files that do not exist.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single Lean target `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` exists in `Rigidity.lean` (closed).
  - Proof sketch names three load-bearing Mathlib instances + the closure step `ext_of_isDominant_of_isSeparated'`; this is the model level of detail.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Statement of `thm:rigidity_over_kbar` is accurate; signature matches `AlgebraicJacobian/RigidityKbar.lean` (`{kbar : Type u} [Field kbar]`, no `[IsAlgClosed kbar]`). The iter-127 over-k commitment paragraph (lines 14) and § C.2.f "DROPPED" cross-reference are sound.
  - Sub-step (i.a) `\lean{...}` hint on `lem:GrpObj_lieAlgebra` (line 95) does NOT pin a signature stub. Iter-128 prover lane hardcoded `[SmoothOfRelativeDimension 1 G.hom]`; iter-129 must-fix is to relax to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` (per the directive's stated must-fix item, ratified by iter-128 review-phase auditors `lean-auditor-review128.md` and `lean-vs-blueprint-checker-cotangent-grpobj-review128.md`). The chapter's `\lean{...}` hint must include a signature stub of the form `\lean{AlgebraicGeometry.GrpObj.lieAlgebra (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k}` (or equivalent prose pinning) to prevent the iter-130+ relax regressing again.
  - Sub-step (i.a) encoding note (lines 102) authorizes either dualisation convention but does NOT lock in which the iter-128 body chose. Per `lean-vs-blueprint-checker-cotangent-grpobj-review128.md`, the body returns $\eta_G^* \Omega_{G/k}$ (cotangent, $\mathfrak g^\vee$); the file's top docstring says it returns the dual ($\mathfrak g$). The chapter must pin "the body returns $\mathfrak g^\vee$" so the iter-129 docstring fix is unambiguous (or, equivalently, sanction a name change `lieAlgebra → cotangentSpaceAtIdentity` and update the `\lean{...}` hint accordingly).
  - **Missing rank-lemma bridge.** Sub-step (i.a) proof (lines 105–109) sketches the $\mathfrak m / \mathfrak m^{2}$-stalk presentation via `IsRegularLocalRing.cotangentSpace`; sub-step (i.a) rank lemma (lines 117–126) re-sketches the same route. But the iter-128 Lean body of `lieAlgebra` (`Cotangent/GrpObj.lean:87–101`) routes through `relativeDifferentialsPresheaf G.hom` evaluated at the top open + `ModuleCat.extendScalars` along `Γ(G.left, ⊤) ⟶ k`. The blueprint provides no bridge connecting "presheaf-evaluation-then-extend-scalars" (Lean body shape) and "$\mathfrak m / \mathfrak m^{2}$ stalk" (chapter proof shape). An iter-129+ rank-lemma prover lane would have to invent this bridge itself. **This is the central must-fix-this-iter blueprint-writer task** (per the directive).
  - Pieces (ii) and (iii) of the shared pile are documented in a single bullet each (lines 68, 70–76) with no sub-step decomposition. This is OK for iter-129 (only piece (i) is active), but pieces (ii) and (iii) will need their own chapters or chapter sections before iter-131+ build lanes can target them; queue blueprint-writer work for iter-130+ once piece (i) sub-step (i.a) closes.
  - Piece (iv) Serre duality DEFERRED disclosure is clean (lines 78).

## Cross-chapter notes

- **Orphan-chapter cluster.** `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex` are all internally consistent with each other (they share the C0→C1→C2 narrative arc), but the entire arc is orphaned from the Lean tree. The corresponding Lean files were excised during the iter-126/127 strategic shift to the Albanese-witness route. Recommendation: a single blueprint-writer dispatch this iter to either (a) delete all four chapters, or (b) prepend a one-paragraph "Historical: this chapter documents a strategic route the project has retired in favor of the Albanese-witness route of Chapter~\ref{chap:Jacobian}; the named Lean files were excised iter-126/127" disclaimer to each and remove all `\lean{...}` hints + `\leanok` markers so they no longer pollute the dependency graph or `sync_leanok` output. Option (a) is the cleaner long-term solution.

- **`Jacobian.tex` § C.2.a over-$\bar k$ prose vs. `RigidityKbar.tex` over-k statement.** `Jacobian.tex` § C.2.a (line 322) opens "Statement (over $\bar k$)" and `Jacobian.tex` § C.2 prologue (line 319) says "We state the rigidity result over the algebraic closure $\bar k$… The conclusion over $k$… then follows by Galois descent (Sub-step~C.2.f)." But § C.2.f (line 352) says "DROPPED iter-127", and `RigidityKbar.tex`'s actual declaration is over an arbitrary field. The two chapters do not contradict each other on the conclusion, but `Jacobian.tex`'s framing in § C.2 introduction creates the false impression that an over-$\bar k$-and-descend pass is still being used. Internal-consistency soon-item; not blocking.

- **`Differentials.tex` § Mathlib references vs. `RigidityKbar.tex` rank-lemma proof.** `Differentials.tex`'s `thm:smooth_locally_free_omega` exists and names `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` as the rank-pinning Mathlib piece. The `RigidityKbar.tex` rank-lemma `lem:GrpObj_lieAlgebra_finrank` consumes essentially the same machinery (rank of a Kähler differential at a smooth point equals relative dimension), but does not cross-reference to `Differentials.tex`'s already-formalised rank machinery. A blueprint-writer pass on `RigidityKbar.tex` could shorten the rank-lemma proof to one line: "Specialise `thm:smooth_locally_free_omega` to the chart at $\eta_G$ and apply the rank lemma; the smoothness + finite-rank-of-dual chain pins $\finrank_k \mathfrak g = n$." This would also free the rank lemma from re-rolling `IsRegularLocalRing.cotangentSpace`. Soon-item; not blocking.

## Strategy-modifying findings

None. The strategy snapshot (single route, M2 via `rigidity_over_kbar` over `k` + cotangent-vanishing pile (i)+(ii)+(iii); piece (iv) deferred) is consistent with the blueprint's active (i.e., non-orphan) chapters.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` § Piece (i.a): `\lean{...}` hint on `lem:GrpObj_lieAlgebra` needs a signature stub binding `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` (not the bare `1`); the chapter must also pin which dualisation convention the iter-128 body returns ($\mathfrak g^\vee$ per the auditor consensus). Active prover route this iter (iter-129 must-fix items per directive). **Lean target is part of the active iter-129 plan.**
  - `RigidityKbar.tex` § Piece (i.a): the rank-lemma bridge between the evaluate-first body construction (Lean) and the $\mathfrak m / \mathfrak m^{2}$ stalk presentation (chapter proof sketch) must be authored. Without it, the iter-129+ rank-lemma prover lane has nothing to anchor its closure to.
  - `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`: orphan chapters. Either delete or strip `\lean{...}` + `\leanok` markers so they don't pollute the dependency graph or `sync_leanok` output.

- **soon**:
  - `Jacobian.tex` § C.2.a + § C.2 prologue: prose framing should shift from over-$\bar k$ to over-$k$ to match the iter-127 commitment already enacted in § C.2.f and the shared pile.
  - `RigidityKbar.tex` rank-lemma proof: cross-reference `Differentials.tex` `thm:smooth_locally_free_omega` to shorten the closure path.
  - `RigidityKbar.tex` § Pieces (ii) and (iii): need sub-step decomposition before iter-131+ build lanes (queue blueprint-writer for iter-130+ once iter-129 piece (i.a) lands).
  - `RigidityKbar.tex` rank-lemma `\lean{...}` hint: add inline signature-stub for clarity (mid-grade hint currently).

- **informational**:
  - `RigidityKbar.tex` legacy variable name `kbar`: low-priority rename to `k` per the chapter's own iter-127 over-k commitment paragraph (scheduled iter-128+).
  - `Cohomology_StructureSheafModuleK.tex` line 4 has a small prose redundancy ("the parallel $\Module k$-valued construction" appearing twice in adjacent paragraphs); no impact on Lean targets.

**Overall verdict**: 14 chapters audited; 10 are healthy or have only soon/informational findings; 4 are orphans needing strip-or-delete this iter; `RigidityKbar.tex` has two must-fix items (signature-stub + rank-bridge) directly on the iter-129 active prover route, so a `blueprint-writer` dispatch on `RigidityKbar.tex` is required before any iter-129 prover lane on `Cotangent/GrpObj.lean` (or its iter-129+ rank-lemma sibling) fires.
