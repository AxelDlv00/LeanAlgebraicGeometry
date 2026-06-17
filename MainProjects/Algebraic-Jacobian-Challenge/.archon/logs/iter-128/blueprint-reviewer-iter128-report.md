# Blueprint Review Report

## Slug
iter128

## Iteration
128

## Top-level summaries

### Incomplete parts

None of the in-tree chapters are incomplete in a way that blocks the iter-128 prover-lane dispatch on `Cotangent/GrpObj.lean`.

- (Orphan, not in `content.tex`) `Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex` reference Lean declarations (`AlgebraicGeometry.Scheme.LineBundle`, `Scheme.PicardFunctor`, `Scheme.PicardFunctorAb`, `Scheme.SheafOfModules.pullback_tensorObj`, …) for which no `Modules/` or `Picard/` subdirectory exists in `AlgebraicJacobian/`. Their statements assume strategy routing that the project no longer pursues (Phase~C / Pic-scheme route was supplanted by the Albanese exit policy now in `Jacobian.tex`). They are dead-weight from a prior strategy iteration. See *Cross-chapter notes* below for recommended cleanup; they do not block any active prover lane.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_lieAlgebra` (lines 101–103): the proof sketch is three sentences and routes through two un-named Mathlib bridges — (a) "the pullback $\eta_G^*\Omega_{G/k}$, on evaluation at $\Spec k$, is the cotangent space $\mathfrak m/\mathfrak m^2$ of the local ring $\mathcal O_{G,\eta_G}$" (this identifies a section-pullback of a relative-cotangent presheaf with a Zariski-stalk-side cotangent — a non-trivial Mathlib bridge that the project's existing `def:relative_kaehler_presheaf` does not directly supply); (b) "regular ⇒ finite generation and freeness of $\mathfrak m/\mathfrak m^2$" (correct, but Mathlib's `IsRegularLocalRing.finrank_cotangentSpace` / equivalent should be named). Compare with `Differentials.tex § thm:smooth_locally_free_omega`, which step-by-step names five `[verified]` Mathlib closure pieces; that is the project's prover-ready standard. — *Soon* (not must-fix): sufficient for staging sorry-bodied targets, but the prover may fail to close without further blueprint refinement.
- `RigidityKbar.tex` / `lem:GrpObj_lieAlgebra_finrank` (lines 116–118): "the cotangent space at a smooth point of a $d$-dimensional scheme is a $d$-dimensional $k$-vector space" — a major classical fact stated without a named Mathlib closure piece. The companion identification "$\dim_{\eta_G}\,G = \dim G$ when $G$ is geometrically irreducible" is also un-named. The numerical $\dim G$ as used here should be the relative-dimension parameter $n$ of `SmoothOfRelativeDimension n G.hom` (this is the convention `Jacobian.lean`'s `JacobianWitness.smoothGenus` field already uses); the blueprint does not pin this Lean encoding. — *Soon*.
- `RigidityKbar.tex` / `lem:GrpObj_mulRight_globalises` (lines 139–146): the categorical sigma-tau-inversion is sketched well, but the natural-isomorphism conclusion $\Omega_{G/k} \cong \mathrm{pr}_1^*(\eta_G^*\,\Omega_{G/k})$ is asserted without naming the Mathlib infrastructure for pulling back / restricting along a section in the relative-cotangent-presheaf framework. *Soon*; piece (i.b) is downstream of (i.a) and out-of-scope for iter-128 dispatch.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}`: signature is well-defined in prose ("finitely generated free $k$-module"), but the Lean **return type** is not pinned. Is it `ModuleCat k`, a bundled `Module.Free k _`, or a `(carrier, freeness-proof)` tuple? The proof sketch hands a `\Spec k`-evaluation of a presheaf section, which in Mathlib's `relativeDifferentialsPresheaf` framework yields a `ModuleCat (f^{-1}_{psh} \mathcal O_S)(V)` — not a bare `k`-module without further bridge work. *Soon* (the prover or autoformalizer will need to pick a Lean type; the directive's "smallest signature surface" framing tolerates this latitude).
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}`: signature is in principle clear (`Module.finrank k (lieAlgebra ...) = ?n`), but the right-hand `?n` is "$\dim G$" without a Lean expression: is it `n` from a `[SmoothOfRelativeDimension n G.hom]` instance, or the `Module.finrank k _` of the cotangent (circular), or `topologicalKrullDim`? *Soon*.

### Multi-route coverage

- Route "**over-k baseline** (iter-127 commitment)": **PASS**. Covered in `RigidityKbar.tex` (introduction + `\S$ Iter-127 over-k commitment + piece-(i) sub-decomposition`), with `\thm{thm:rigidity_over_kbar}` packaging the over-k statement, and in `Jacobian.tex` via `def:genusZeroWitness` (iter-127 scaffold) which invokes `thm:rigidity_over_kbar` directly with the $k$-rational marked point and is vacuously true on $C(k) = \emptyset$. The over-k commitment is consistently asserted in both chapters' high-level prose and in the "infrastructure summary" $(\alpha)/(\beta)/(\gamma)$ paragraph of `Jacobian.tex`.
- Route "**over-k̄ fallback**": Implicit, retained as historical framing in `Jacobian.tex § C.2.a–C.2.e` (still written in pre-iter-127 over-$\bar k$ prose) and in `Rigidity.tex § "Use in the project"` (mentions $\mathbb P^1_{\bar k}$, $A_{\bar k}$). This is **internally inconsistent** with the over-k commitment in `RigidityKbar.tex` and with the C.2.f/C.2.g/$(\gamma)$ blocks of `Jacobian.tex` itself. See *Cross-chapter notes*. Not a coverage gap (the fallback is still nominally a viable route), but a coherence finding. *Soon*.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single transport-of-sheaf-condition instance; cleanly leverages limit-preservation. Used by `Cohomology_StructureSheafAb.tex § def:Scheme_toAbSheaf`. Not in any iter-128 dependency.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Sheafification / `\Ext` / `toAbSheaf` are all stated with `\leanok`. Universe-pinning concerns are explicit in remarks.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase~A step~5 is closed at the level of carriers + carrier predicates + producer instances. The two carrier classes `IsAffineHModuleVanishing` / `IsAffineHModuleHomFinite` are honestly documented as currently unproduced (consistent with `Cohomology_MayerVietoris.tex § "Producer status"`).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long-form chapter with extensive `\leanok` coverage and a clear carrier/consumer separation. `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` are honestly named-deferred producer hypotheses.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - This chapter is the project's gold standard for prover-ready proof-sketch density: `thm:smooth_locally_free_omega` enumerates five `[verified]` Mathlib closure pieces by name. The piece-(i) targets in `RigidityKbar.tex` are not at this density (see *Proofs lacking detail* above) but the gap is *soon*, not must-fix.
  - M1 excise (iter-126) is clearly documented; the two retained K\"ahler-localization utilities (`lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso`) are standalone Mathlib-PR candidates.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` body is closed (`\leanok`), Mathlib-gap (Serre finiteness for $H^1$ of a proper $k$-curve) is honestly named.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **iter-127 fix re-verified.** `def:genusZeroWitness` block is present at lines 383–411 with a thorough multi-paragraph proof sketch invoking `thm:rigidity_over_kbar` directly over $k$. The `\notready` marker is present on the statement and `\leanok` on the proof block (reflecting that the body of `genusZeroWitness` is the project-side residual `sorry`). Cross-references to `RigidityKbar.tex` and the iter-127 over-k commitment are clean.
  - **Cross-coherence finding (over-k vs over-$\bar k$ within the same proof).** The `thm:nonempty_jacobianWitness` proof (lines 247–376) is internally inconsistent on the framing of the genus-$0$ sub-case:
    - `\S$ Genus-$0$ sub-case` (lines 313–319) opens by saying "We state the rigidity result over the algebraic closure $\bar k$, since the protected signature of Theorem~\ref{thm:nonempty_jacobianWitness} does not assume $C(k) \neq \emptyset$ and the genus-$0$ identification $C \cong \mathbb P^1$ is only available after passing to $\bar k$…"
    - C.2.a–C.2.e (lines 321–351) are written entirely in over-$\bar k$ prose ($\mathbb P^1_{\bar k}$, $A_{\bar k}$, "closed point $p \in \mathbb P^1_{\bar k}(\bar k)$").
    - C.2.f is then marked "[DROPPED iter-127]" and C.2.g states the iter-127 over-k inventory.
    - C.3 ("the trivial witness") invokes "By Sub-step C.2 every $f \colon C \to A$ with $f(P) = \eta_A$ is constant at $\eta_A$" — but C.2.a–C.2.e in the same paragraph talk about $\mathbb P^1_{\bar k} \to A_{\bar k}$, not $C \to A$ over $k$.
    - The infrastructure summary `($\gamma$)` (lines 369–372) and the M2.a body of `def:genusZeroWitness` (lines 391–411) state the over-k commitment cleanly.
    This is *soon* (not must-fix-this-iter): the iter-128 piece-(i.a) prover lane is in `Cotangent/GrpObj.lean` and is unaffected by the C.2.a–C.2.e prose. But the chapter would benefit from a follow-up writer pass to rewrite C.2.a–C.2.e in over-k prose to match the committed direction (or convert them into a clearly-labelled "Historical over-$\bar k$ exposition" subsection).
  - The 16 occurrences of `\bar k` in this chapter (verified count) are not all stale — many appear in legitimate historical / contrastive paragraphs — but a writer pass auditing each one against the iter-127 commitment is warranted.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Scheme-level form is documented with explicit Mathlib closure pieces. `\S$ "Use in the project"` mentions $\mathbb P^1_{\bar k} \to A_{\bar k}$ once — this is the same over-$\bar k$ stale-prose pattern flagged above for `Jacobian.tex`, but at lower severity since this chapter is a consumer-side cross-reference, not the active formulation site. *Soon* (cleanup item).
  - The named-target `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` exists in `Rigidity.lean` (iter-125 refactor). `\leanok` on statement and proof is honest.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **iter-127 fix re-verified.** `\S$ Iter-127 over-k commitment` paragraph (lines 14) is in place; introduction (lines 1–14) is fully over-k. `\S$ Piece (i): sub-lemma decomposition for iter-128+ build` (lines 81–178) is present and contains: 5 lemma blocks (`lem:GrpObj_lieAlgebra`, `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) plus 1 remark (`rem:piece_i_first_target`). All five carry `\notready` on the statement block. The "Iter-127 over-k risk register" paragraph on the shear-iso functorial formulation (lines 136) is a strong piece of guidance.
  - **For the iter-128 piece-(i.a) targets specifically:** `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` (line 92) and `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}` (line 107) are well-formulated as $k$-vector-space rank assertions about $\eta_G^*\,\Omega_{G/k}$ at a $k$-rational identity section. Proof sketches are *compressed* (see *Proofs lacking detail* and *Lean difficulty quality*), but mathematically correct and cross-reference the project's existing `def:relative_kaehler_presheaf`.
  - Sub-step (i.b) and (i.c) staging is consistent with the directive's "first target = (i.a)" framing; the `\uses{}` chain (`(i.a) → (i.b) → (i.c)`) is well-formed.
  - Honest cost band "1350--2600 LOC over 7--14 iters" for the full pile (pieces (i)+(ii)+(iii)) is documented.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - All four blocks (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) are `\leanok` projections from `IsAlbanese` and ultimately from `thm:nonempty_jacobianWitness`.
  - **Stale over-$\bar k$ prose (sibling to the `Jacobian.tex` finding).** `\S$ "Classical description"` paragraph in the proof of `thm:exists_unique_ofCurve_comp` (lines 80–82) still says "In genus $0$, the same statement reduces to the rigidity theorem for $\mathbb P^1_{\bar k} \to A_{\bar k}$ over the algebraic closure (proved on $C_{\bar k} \cong \mathbb P^1_{\bar k}$ after base change…) together with Galois descent of morphism equality back to $k$" — but per the iter-127 commitment, Galois descent is DROPPED and the genus-$0$ argument is over-k directly. The same paragraph also says "the base-change-and-descent argument handles the no-$k$-rational-point case via vacuity of `isAlbaneseFor`" — but the $C(k)=\emptyset$ branch is vacuous at the Lean *type* level (per `Jacobian.tex § def:genusZeroWitness`), not via "base change and descent." *Soon* (cleanup item, sibling to the `Jacobian.tex` C.2.a–C.2.e rewrite).
  - The mathematical content of the chapter is unaffected; downstream is all `\leanok` projections.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: n/a (not in `content.tex`)
- **correct**: n/a
- **notes**:
  - **Orphan chapter.** Not `\input` in `content.tex`. References `AlgebraicGeometry.Scheme.Modules.tensorObj`, `Scheme.Modules.instMonoidalCategory`, `Scheme.Modules.instIsMonoidal_W` — none of which exist in the Lean tree (`AlgebraicJacobian/Modules/` subdirectory does not exist; verified via `find` on `AlgebraicJacobian/`).
  - The "load-bearing post-C1" framing is from a prior strategy iteration that has been superseded by the Albanese exit policy (`Jacobian.tex § "Implementation route via the Albanese functor"`).
  - **Recommendation:** delete this chapter (and the three Picard_*.tex files below). *Soon* / cleanup; zero impact on iter-128.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: n/a (not in `content.tex`)
- **correct**: n/a
- **notes**:
  - **Orphan chapter.** Same status as `Modules_Monoidal.tex`. References `Scheme.LineBundle`, `Scheme.Pic.pullback`, `Scheme.SheafOfModules.pullback_tensorObj`, `Scheme.SheafOfModules.pullback_oneIso` — none in the Lean tree. *Soon* / cleanup.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: n/a (not in `content.tex`)
- **correct**: n/a
- **notes**:
  - **Orphan chapter.** Same status. *Soon* / cleanup.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: n/a (not in `content.tex`)
- **correct**: n/a
- **notes**:
  - **Orphan chapter.** Same status. *Soon* / cleanup.

## Cross-chapter notes

- **Over-k vs over-$\bar k$ prose inconsistency** (`Jacobian.tex § C.2.a–C.2.e`, `Jacobian.tex § "Classical description" of thm:exists_unique_ofCurve_comp` in `AbelJacobi.tex`, and `Rigidity.tex § "Use in the project"`): the prose in these blocks is written in the pre-iter-127 over-$\bar k$ framing ("$\mathbb P^1_{\bar k} \to A_{\bar k}$", "Galois descent of morphism equality") while the *committed* framing of the project (per `RigidityKbar.tex` introduction + iter-127 over-k analogist `analogies/cotangent-vanishing-pile-over-k.md` + `Jacobian.tex § "Mathlib infrastructure summary"`) is over-k directly. The historical decomposition C.2.a–C.2.e remains mathematically valid (the over-$\bar k$ argument is a special case after base change), but the framing is misaligned with the route the project is now executing. **Severity:** *soon*, not must-fix; the iter-128 piece-(i.a) prover lane is in `Cotangent/GrpObj.lean` and operates orthogonally to this prose. A coordinated cleanup pass — best left to one writer touching `Jacobian.tex` + `AbelJacobi.tex` + `Rigidity.tex § "Use in the project"` together — is recommended for a post-iter-128 iteration.
- **Orphan chapters cluster** (`Modules_Monoidal.tex` + `Picard_LineBundle.tex` + `Picard_Functor.tex` + `Picard_FunctorAb.tex`): these four chapters cross-reference each other and the now-`\leanok` `thm:nonempty_jacobianWitness` (which they predate as the load-bearing existence hypothesis), but no in-tree chapter cross-references them (verified by grepping their `\label`s and `\lean{...}` Lean-target names against the eight in-tree chapters — only the four orphan chapters refer back to these labels). They occupy ~530 lines of detailed but route-superseded blueprint and reference non-existent Lean declarations. **Recommendation:** delete in a follow-up iteration. Confirm with the user / strategy-critic that the Albanese exit policy is final before deletion.
- **Naming-idiom alignment.** `RigidityKbar.tex § "Piece (i)"` correctly aligns with the `GrpObj` namespace per the iter-126 mathlib-analogist consult (`analogies/cotangent-vanishing-pile.md`). No mismatch with Mathlib snapshot `b80f227` (which has no `AbelianVariety` file, only `GrpObj`); the choice is well-documented.

## Strategy-modifying findings (if any)

None. The iter-127 over-k commitment is consistently held across the prover-relevant blocks (`RigidityKbar.tex`, `Jacobian.tex § def:genusZeroWitness`, `Jacobian.tex § ($\gamma$)`). The stale over-$\bar k$ prose flagged above is prose-level only and does not contradict the committed strategy.

## Hard-gate verdict for iter-128 prover dispatch on `Cotangent/GrpObj.lean`

**PASS.** Applying the dispatcher's hard gate verbatim:

- The corresponding blueprint coverage for the two iter-128 prover targets (`AlgebraicGeometry.GrpObj.lieAlgebra`, `AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim`) lives in `RigidityKbar.tex § "Piece (i): sub-lemma decomposition for iter-128+ build"`, lines 81–178.
- `RigidityKbar.tex`: `complete: true`, `correct: true`.
- No must-fix-this-iter finding touches `RigidityKbar.tex`. The proof-sketch-compression and Lean-difficulty-quality findings are classified *soon*, on the grounds that (i) the directive explicitly stages piece (i.a) as the iter-128+ prover lane's *first* target with the *smallest* signature surface and *no* scheme-level globalisation, (ii) the cited Mathlib bridges (`IsRegularLocalRing.finrank_cotangentSpace`-style, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`) are standard and a competent prover round can elicit them from `lean_leansearch` / `lean_state_search`, and (iii) the existing `Differentials.tex` chapter sets a precedent for naming the closure pieces during prover work rather than pre-blueprinting them.

The plan agent may therefore add `Cotangent/GrpObj.lean` to `## Current Objectives` for iter-128 prover dispatch, mapping the lemma blocks `lem:GrpObj_lieAlgebra` and `lem:GrpObj_lieAlgebra_finrank` to the file's two declarations. **No fresh `Cotangent_GrpObj.tex` chapter is required this iter** — the staged coverage inside `RigidityKbar.tex § "Piece (i)"` is the right shape (piece (i.a)'s decomposition belongs adjacent to its consumer `thm:rigidity_over_kbar`, not in a parallel chapter); a `Cotangent_GrpObj.tex` extraction would be a writer-side stylistic preference, not a coverage requirement.

If the prover fails to close the bodies of `lieAlgebra` / `lieAlgebra_finrank_eq_dim` on the first attempt (a non-trivial possibility given the proof-sketch compression), the natural iter-129 follow-up is a *blueprint-writer* dispatch on `RigidityKbar.tex § "Piece (i)"` to expand the proof sketches into prover-ready step-by-step closures naming the specific Mathlib pieces (cf. the `[verified]` pattern of `Differentials.tex`), then re-dispatch the prover.

## Severity summary

- **must-fix-this-iter**: *none*.
- **soon**:
  - Expand the proof sketches of `lem:GrpObj_lieAlgebra` and `lem:GrpObj_lieAlgebra_finrank` in `RigidityKbar.tex` to name the specific Mathlib closure pieces (regularity → finite-rank free $\mathfrak m/\mathfrak m^2$; smooth-point cotangent dimension = relative dimension); pin the Lean return type and the right-hand-side `\dim G` Lean expression in their `\lean{...}` formulations.
  - Rewrite `Jacobian.tex § C.2.a–C.2.e` from over-$\bar k$ prose to over-k prose to match the iter-127 commitment (or convert into a clearly-labelled historical exposition subsection). Coordinated cleanup with `AbelJacobi.tex § "Classical description"` paragraph and `Rigidity.tex § "Use in the project"`.
  - Delete the four orphan chapters (`Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`) after the strategy-critic confirms the Albanese exit policy is final.
- **informational**:
  - Per-piece build order in `RigidityKbar.tex § "Honest pile cost"` (piece (i) → (ii) → (iii)) is well-documented; informational pointer for future iters.
  - `RigidityKbar.tex § "Iter-127 over-k risk register"` paragraph (lines 136) on the *functorial* shear-iso formulation (not pointwise translation) is excellent prover-side guidance; iter-128 prover lane should preserve this discipline.

Overall verdict: 8 in-tree chapters audited (4 orphan chapters n/a), all 8 are coherent enough for the strategy, the iter-127 fixes (piece-(i) decomposition in `RigidityKbar.tex`, `def:genusZeroWitness` in `Jacobian.tex`, multi-route over-k commitment) are all in place; the prover dispatch on `Cotangent/GrpObj.lean` for piece (i.a) is **green-lit**, with sibling improvement work (proof-sketch expansion, prose coherence cleanup, orphan-chapter deletion) deferred to *soon*.
