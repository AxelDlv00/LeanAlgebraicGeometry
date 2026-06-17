# Blueprint Review Report

## Slug

iter117

## Iteration

117

## Top-level summaries

### Incomplete parts

Sorted roughly by severity (higher first; chapters whose blocker also gates the protected declarations come first).

- `Jacobian.tex` / `thm:nonempty_jacobianWitness` — the "single working hypothesis" that funds *all four* protected Jacobian instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) AND `def:Jacobian` AND the Abel-Jacobi chapter's `exists_unique_ofCurve_comp`. The chapter does list two classical construction routes (Pic^0 / Sym^g) plus the genus-0 case (Brauer–Severi rigidity `Hom(ℙ¹,A) = A(k)`), but **explicitly bundles all three into one existence claim and concedes "Mathlib currently contains neither Pic-scheme representability, nor symmetric powers / quotients of schemes by finite group actions, nor the rigidity theorem"**. The Lean side at `AlgebraicJacobian/Jacobian.lean:179` is a literal `sorry`. Under the user directive "no temporarily wrong; the blueprints should be detailed enough", this chapter must be split into the three subclaims (or have STRATEGY.md authorise scope contraction); the current single-stub is exactly the "named Mathlib gap; deferred" pattern the user is overriding.
- `Picard_Functor.tex` / `thm:Pic_representable` — full proof body is *literally* "See *Fundamental Algebraic Geometry: Grothendieck's FGA Explained*… and Mumford, *Abelian Varieties*". No subclaim decomposition, no Mathlib gap-named lemmas, no path. Lean body at `AlgebraicJacobian/Picard/Functor.lean:181` is a literal `sorry`. A prover cannot formalise this from the chapter; the chapter's own §`Use in the project` admits the project route is to bypass it via `nonempty_jacobianWitness`.
- `Differentials.tex` / `thm:serre_duality_genus` — declaration block has **NO `\begin{proof}` block** at all. Only an out-of-place `\begin{remark}` (the geometric-irreducibility gap remark) sits below. The corresponding Lean theorem at `AlgebraicJacobian/Differentials.lean:1091-1097` is a literal `sorry`. This is the deepest chapter and the prover has zero actionable decomposition for this theorem (compare with `thm:smooth_iff_locally_free_omega` and `thm:cotangent_exact_sequence` in the same chapter, which both carry multi-paragraph proof sketches with named Mathlib lemmas — those are the model). Must-fix.
- `Differentials.tex` / `lem:cotangent_exact_structure`, sub-claim `case h_exact` — explicitly deferred "parallel to `instIsMonoidal_W`" pending `SheafOfModules.stalkFunctor` and homology-preservation instances. The `% NOTE:` admits both routes (stalkwise and section-wise) are infrastructurally blocked. Lean body around line 856 has an inline `sorry`.
- `Modules_Monoidal.tex` / `instIsMonoidal_W` (no `\lean{...}` hint of its own — the chapter inlines it as Remark~\ref{rem:W_IsMonoidal_content} and the closure status note at the chapter end) — the chapter's "Mathematical content" remark *is* the proof discussion, but it is in a `remark` block, **not in a `proof` block on a numbered theorem**, so the dependency graph cannot see it. The Lean side at `AlgebraicJacobian/Modules/Monoidal.lean:173` is a literal `sorry`. The chapter (Remark~\ref{rem:W_IsMonoidal_load_bearing}) honestly discloses that *every* C1+ theorem now transitively depends on this `sorry`. Per directive: this is a named-deferred Mathlib gap that under the new directive must either become a numbered theorem with a real proof decomposition (e.g. `monoidal_iff_stalkwise_iso → varying-ring stalk-tensor identification`) or be removed from scope.
- `Picard_LineBundle.tex` / `thm:SheafOfModules_pullback_tensorObj` AND `thm:SheafOfModules_pullback_oneIso` — pair of named-deferred Mathlib gaps. Each statement is correct; proof sketches reference Stacks 01AC but stop at "Mathlib b80f227 does not register a `Functor.Monoidal …` instance". Bodies in `AlgebraicJacobian/Picard/LineBundle.lean:86` and `:98` are literal `sorry`. Same pattern as `instIsMonoidal_W`: under the new directive these are not acceptable as standing axioms.
- `Cohomology_MayerVietoris.tex` / `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 2 transport substep (iv) — explicitly labelled "budget deferral, not Mathlib gap" (Remark~\ref{rem:basicOpenCover_step2_status}). The chapter says the necessary Mathlib API is present (`IsLocalizedModule.pi`, `prodMap`, etc.) but the proof-engineering of threading `letI`-binders has been parked. Inline `sorry` at `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1846`. Plus five further labelled transient sorries in the same theorem body (lines 1120, 1212, 1536, 1564, 1754).
- `Genus.tex` — Mathlib-gap section names Serre finiteness as the "remaining gap for the *theorem* of genus" but does NOT include in this chapter any decomposition of how the gap will be discharged — the actual decomposition lives in `Cohomology_StructureSheafModuleK.tex` / `Cohomology_MayerVietoris.tex` (\v{C}ech approach). The cross-reference is implicit; the chapter should either point at the specific Čech-acyclicity producer (`thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`) or carry a brief acknowledgement of the discharge route.

### Proofs lacking detail

These are blocks where a proof *exists* but the user directive's "detailed enough for a prover" bar is not met.

- `Cohomology_SheafCompose.tex` / `thm:HasSheafCompose_forget` — proof body is 3 lines: "Both forgetful functors create all small limits. Composing limit-preserving functors gives a limit-preserving functor". Adequate for the typeclass body it produces, but does not name *which* Mathlib lemma packages "preserves limits ⇒ preserves sheaf condition". A prover would have to discover `CategoryTheory.Sheaf.isSheaf_of_isLimit_preserving` or the equivalent themselves. Soon, not must-fix (the Lean body is short).
- `Cohomology_StructureSheafAb.tex` / `thm:HasSheafify_Opens_AddCommGrp`, `thm:HasExt_Sheaf_Opens_AddCommGrp` — both proofs reduce to "instance is therefore inferable; the formal task is to establish the universe pinning". This is true but does not tell a prover *which* universe annotations to thread. The Lean file builds without sorries here, so the gap is informational, but the chapter is the model for the parallel ModuleK chapter — if these are inferable, that should be stated as "by `inferInstance` after the universe pinning … the pinning is set by …".
- `Cohomology_StructureSheafModuleK.tex` / `thm:HasSheafify_Opens_ModuleCatK`, `thm:HasExt_Sheaf_Opens_ModuleCatK` — same shallow-inferability proof shape. Same observation.
- `Picard_FunctorAb.tex` / `def:PicardFunctorAb_etaleSheafified` — proof: "Apply the Mathlib sheafification left-adjoint to `PicardFunctorAb C` directly." But the chapter immediately admits the post-iter-109 universe bump is what makes this go through; a prover may need an explicit citation of the `HasSheafify` instance for the étale topology at `AddCommGrpCat.{u+1}` rather than the bare "inferable" claim.
- `Jacobian.tex` / `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred` — these four protected instances each have a one-line proof reference to "the Albanese construction" and a global summary paragraph that says they "descend from the corresponding properties of C because the Albanese map is surjective with connected fibres". But the Lean implementation actually projects each from `JacobianWitness.proper`/`.smooth`/etc. — i.e. the proof is just `(jacobianWitness C).proper`. The chapter should say so explicitly: "projects the corresponding field of `JacobianWitness`". This is also a name-drift case (Lean's field names are `proper`, `smooth`, `geomIrred`, `smoothGenus`; the chapter never lists them).
- `AbelJacobi.tex` / `lem:comp_ofCurve` — the proof gives a line-bundle-style argument ("Globally: by construction, α_P is the morphism classifying the line bundle O_{C×C}(Δ - p_1^* P); restricting to the section (P, id) gives the trivial line bundle"), but the Lean proof body is `((jacobianWitness C).isAlbaneseFor P).comp_ofCurve` — i.e. a one-line projection from the witness field. The line-bundle prose is mathematically true but mis-leads the prover about the formalisation route. Either rewrite the proof sketch to match the Albanese projection or split into "classical proof" + "what the formalisation does".

### Lean difficulty quality

`\lean{...}` hints whose target is poorly formulated for a prover:

- `AbelJacobi.tex` / `def:ofCurve` / `\lean{AlgebraicGeometry.Jacobian.ofCurve}` — declared correct (matches `AlgebraicJacobian/AbelJacobi.lean:51`), **but** the chapter's informal description ("the morphism induced by the line bundle O_{C×C}(Δ - p_1^* P) on C×C via the universal property of Pic^0_{C/k}") is a different mathematical construction than the Lean implementation route (Albanese-witness projection: `((jacobianWitness C).isAlbaneseFor P).ofCurve`). The chapter §"Implementation route via the Albanese framework" disclaims this, but the **declaration block itself is misleading** — a downstream prover reading only the definition box would build the wrong tensor of pullbacks for the line bundle. The fix is: rewrite the definition block to lead with the Albanese-projection definition and demote the line-bundle classifying-morphism prose to a `remark` block ("classical description").
- `Jacobian.tex` / `def:IsAlbanese` / `\lean{AlgebraicGeometry.IsAlbanese}` — the prose says "A smooth proper geometrically irreducible group scheme J over k is an Albanese object". The Lean declaration takes those four conditions as **typeclass parameters** (`[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]`), not as conjuncts inside the body. This is the right encoding, but the chapter does not flag that the typeclass arguments are part of the signature, not the conclusion. A prover building consumers will need to thread these as instances at every use site (which is what `AbelJacobi.lean`'s `letI`-chain does); the chapter should call this out.
- `Jacobian.tex` / `thm:nonempty_jacobianWitness` / `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` — exists at `AlgebraicJacobian/Jacobian.lean:176` with the signature given. The hint is fine; what fails is the proof-side detail (see "Incomplete parts").
- `Modules_Monoidal.tex` / `instIsMonoidal_W` — the chapter has no top-level `\lean{...}` hint for this instance even though it is a *load-bearing named-deferred Mathlib gap* referenced from at least three downstream chapters (Picard_LineBundle, Picard_Functor, Picard_FunctorAb). The disclosure paragraph mentions `\texttt{instIsMonoidal\_W}` by name but the absence of a dedicated theorem/`\lean{...}` block keeps it invisible to the dependency graph. Soon-grade: any consumer chapter that wants to depend on it via `\uses{...}` has no label to cite.

### Multi-route coverage

Single-route project (no `## Routes` block in directive). The strategy is the Albanese framework; the Picard-scheme route is described in the chapters but explicitly bypassed via `nonempty_jacobianWitness`. Coverage:

- **Route "Albanese framework"** (active): PASS — covered in `Jacobian.tex`, `AbelJacobi.tex`, `Rigidity.tex` (uniqueness half). Modulo the must-fix items above.
- **Route "Pic^0 via FGA"** (informational, bypassed): PARTIAL — described in `Picard_Functor.tex` `thm:Pic_representable` and connected via `\uses{...}` to `Picard_LineBundle`, but the chapter `Picard_Functor.tex` makes no progress on it and explicitly defers to FGA. Not a current prover route, so no coverage gap that blocks an active objective.
- **Route "Sym^g(C) → Pic^g symmetric power"** (informational, bypassed): MISSING from the blueprint as a standalone chapter — only mentioned in passing inside `Jacobian.tex`'s `thm:nonempty_jacobianWitness` proof sketch. Not a current prover route either.

## Per-chapter

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Self-contained, single-theorem chapter. Statement matches `\lean{AlgebraicGeometry.GrpObj.eq_of_eqOnOpen}` at `AlgebraicJacobian/Rigidity.lean:79`. Proof sketch (Mumford symmetric form) is paragraph-detailed and lists Mathlib ingredients: separatedness-from-properness, equaliser-closed, irreducibility, smoothness ⇒ reducedness, group-object structure. The "provable in this iteration" claim at the end of §Mathlib gap is testable.
  - One info-grade item: the §Use in the project paragraph cites Theorem~\ref{thm:exists_unique_ofCurve_comp} but the rigidity-based uniqueness argument it describes ("applied to δ = g₁·g₂⁻¹ on the image of α_P, a non-empty open after passing to the symmetric power C^(g) ↠ Jac(C)") is the *classical* uniqueness argument, not the *formal* one (which is bundled into `IsAlbanese.unique` via the Albanese universal property). Worth a one-liner.

### blueprint/src/chapters/Genus.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Definition correct; matches `\lean{AlgebraicGeometry.genus}` at `AlgebraicJacobian/Genus.lean:65`. §"User authorisation of `noncomputable`" is correct and current.
  - §Mathlib gap names Serre finiteness as the remaining gap but does not point at the specific Čech-acyclicity producer chain (`thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` + the `IsAffineHModuleVanishing`/`IsHModuleHomFinite` consumers in `Cohomology_StructureSheafModuleK.tex`/`Cohomology_MayerVietoris.tex`). A prover scanning Genus.tex sees a stub "deferred to iterations beyond this chapter" without learning that the discharge plan exists.
  - The "equivalent reformulations" bullet list is informational only; one of the three (Serre duality) is now `thm:serre_duality_genus` in Differentials.tex but Genus.tex doesn't `\uses{}` it. Add the cross-ref.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Statements for the four protected instances + `def:Jacobian` + `def:IsAlbanese` + `thm:IsAlbanese_unique` + `thm:nonempty_jacobianWitness` all match their Lean declarations.
  - **MUST-FIX**: `thm:nonempty_jacobianWitness` is the single working-hypothesis stub. The proof block lists two construction routes (Pic^0, Sym^g) and the genus-0 case (Brauer–Severi rigidity), but does not decompose any of them into subclaims a prover can attack. Under the user directive ("blueprints should be detailed enough to ensure that the provers have enough material") this is the single largest depth deficiency in the project.
  - The four protected-instance proof sketches (`thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred`) describe deformation-theoretic / fibre-connectedness arguments that the formalisation does NOT use — the Lean implementation projects each from `JacobianWitness.grpObj`, `.smoothGenus`, `.proper`, `.geomIrred`. Add a one-paragraph "Lean implementation" remark that names the projection.
  - The §"Implementation route via the Albanese functor" §Layer I and §Layer II split is correct.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - All three protected declarations have correct `\lean{...}` hints matching `AlgebraicJacobian/AbelJacobi.lean` lines 51, 62, 82.
  - **MUST-FIX (mathematical content)**: the `def:ofCurve` definition block describes the Pic^0-line-bundle classifying morphism (`O_{C×C}(Δ − p_1^* P)`), but the formal Lean implementation is the Albanese-witness projection (`((jacobianWitness C).isAlbaneseFor P).ofCurve`). The discrepancy is acknowledged in §"Implementation route via the Albanese framework" but the definition box itself is misleading — a prover working from the definition would search for the wrong Mathlib API (line bundles on C×C, Picard schemes) instead of for the Albanese-witness projection. Either rewrite the definition box, or label the Pic^0 prose as the "classical mathematical content" with a separate "Lean implementation" paragraph mirroring `Jacobian.tex` Layer~I.
  - Same issue at `lem:comp_ofCurve` proof block: the global step describes the line-bundle restriction argument, but the Lean closure is `((jacobianWitness C).isAlbaneseFor P).comp_ofCurve`. Soon-grade fix.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Highly detailed chapter. Most declarations are well-formed and the Lean targets exist (verified `relativeDifferentialsPresheaf`, `cotangentExactSeqAlpha/Beta`, `cotangentExactSeqBeta_hη`, `cotangent_exact_sequence`, `smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`).
  - **MUST-FIX**: `thm:serre_duality_genus` has NO `\begin{proof}` block at all. Only a follow-up `\begin{remark}` (the geometric-irreducibility gap remark). Compare with the model `thm:smooth_iff_locally_free_omega` / `thm:cotangent_exact_sequence` proof sketches in the same chapter, which are multi-paragraph. The Lean side at `AlgebraicJacobian/Differentials.lean:1097` is `sorry`. A prover cannot formalise from this block.
  - **MUST-FIX**: `lem:cotangent_exact_structure` proof has its `\emph{Exactness at the middle}` step explicitly deferred via a long `% NOTE:` that admits both routes (stalkwise + section-wise + sheafification) are blocked. The case-h_exact sorry is recorded as parallel-to-`instIsMonoidal_W`. Under the user directive this is exactly the "named Mathlib gap; deferred" pattern.
  - `lem:sheafOfModules_exact_iff_stalkwise` is explicitly labelled "mathematical statement only; not formalised" and has no `\lean{...}` hint; this is honest disclosure but the user directive overrides the practice.
  - `lem:sheafOfModules_epi_of_epi_presheaf` / `lem:derivation_postcomp_comp` cite Mathlib-shape lemma names; verify these are the actual project-local Lean names (likely `SheafOfModules.epi_of_epi_presheaf` and `PresheafOfModules.Derivation.postcomp_comp` — names match the convention).
  - Lean file has 20 `sorry` occurrences (some are `sorry`-in-prose); the chapter's `\leanok` on `thm:relative_kaehler_isSheaf` and `def:relative_kaehler_sheaf` reflects compilability, not closure of the load-bearing `h_exact` substep.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - All formalised declarations (`tensorObj`, `instMonoidalCategory`, `instBraidedCategory`, `instBraidedCategoryPresheaf`) have matching Lean targets at `AlgebraicJacobian/Modules/Monoidal.lean`.
  - **MUST-FIX**: `instIsMonoidal_W` (the load-bearing named-deferred sorry) is documented across two remarks (`rem:W_IsMonoidal_content`, `rem:W_IsMonoidal_load_bearing`) and the chapter-end §"Formalization status" — but is **not** packaged as a numbered theorem with a `\lean{...}` hint. The mathematical content remark IS a proof sketch in prose ("at the stalk x, the presheaf tensor product computes as ... tensoring with the identity on g_x preserves stalk-level isomorphisms"), but lives in a remark block, so the dependency graph cannot see it as a target. Promote to a numbered theorem `\thm:instIsMonoidal_W` with the proof-sketch prose as its proof body and `\lean{AlgebraicGeometry.Scheme.Modules.instIsMonoidal_W}`.
  - The §"Mathlib gap" list at the chapter end is internally consistent; the disclosure pattern is honest.
  - `def:Modules_Invertible` (the definition of an invertible O_X-module) has no `\leanok` and no `\lean{...}` — likely intentional (the chapter promotes to `LineBundle X` in the next chapter), but cross-chapter consumers of "invertible object" are then untethered.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - All declarations match their Lean targets (`LineBundle`, `Pic`, `instCommGroupLineBundle`, `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp`, `SheafOfModules.pullback_tensorObj`, `SheafOfModules.pullback_oneIso`). Pulled from `AlgebraicJacobian/Picard/LineBundle.lean`.
  - **MUST-FIX**: `thm:SheafOfModules_pullback_tensorObj` and `thm:SheafOfModules_pullback_oneIso` both have proof sketches that stop at "Mathlib b80f227 does not register a `Functor.Monoidal …` instance". Under the directive, these named-deferred Mathlib gaps need either (a) a concrete decomposition (e.g. construct the iso pointwise from the tensor-of-pullbacks-on-stalks identification), or (b) be removed from project scope along with `Pic.pullback`'s downstream consumers. They are sibling deferrals of a single Mathlib gap.
  - The transitively-load-bearing disclosure across `instCommGroupLineBundle` / `Pic.pullback` / `Pic.pullback_id` / `Pic.pullback_comp` is consistent and honest.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `def:Pic_functor` matches `\lean{AlgebraicGeometry.Scheme.PicardFunctor}` at `AlgebraicJacobian/Picard/Functor.lean:149`.
  - **MUST-FIX**: `thm:Pic_representable` proof is "See FGA / Mumford" — zero actionable content for a prover. The chapter's own §"Use in the project" admits the project bypasses this via `nonempty_jacobianWitness`; under the user directive, the theorem should be either decomposed (into the four Step C0–C3 substeps already named in `STRATEGY.md`) **with each substep stated as a labelled subclaim** or removed from blueprint scope (since the active route does not depend on it).
  - §"Post-C1 dependency note" is well-written disclosure of the inherited gaps from `Picard_LineBundle.tex`.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All declarations match Lean targets in `AlgebraicJacobian/Picard/FunctorAb.lean`. Proofs are short but adequate for their inferable nature.
  - One soon-grade item: `def:PicardFunctorAb_etaleSheafified` proof says "the two sheafification instances are inferable" — name them (`HasSheafify` for the étale-on-Sch_k topology at `AddCommGrpCat.{u+1}`) so the prover doesn't grep.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-instance chapter. `\lean{AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp}` matches `AlgebraicJacobian/Cohomology/SheafCompose.lean:39` (declaration exists). Proof body short but adequate for an inferable typeclass.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three declarations (`instHasSheafify_Opens_AddCommGrp`, `instHasExt_Sheaf_Opens_AddCommGrp`, `toAbSheaf`) match their Lean targets at lines 34, 43, 56 of `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`.
  - Soon-grade: proofs reduce to "instance is inferable; universe pinning". For consumers needing to debug an instance failure this is thin. Name the universe annotations and the underlying API (`CategoryTheory.Sheaf.hasSheafify` + the small-site predicate).

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Very large chapter (655 lines), 25 declaration blocks, all with `\leanok` and matching Lean names in `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`. Spot-checks confirmed `HModule`, `HModule'`, `HModule_zero_linearEquiv`, `module_finite_HModule_zero`, the four `*_curve` specialisations, the `IsAffineHModuleVanishing` / `IsAffineHModuleHomFinite` / `IsHModuleHomFinite` carrier predicates, the Stein finiteness theorem `module_finite_globalSections_of_isProper`, and the producer instance `instIsHModuleHomFinite_toModuleKSheaf`.
  - The "two carriers per Phase A step" pattern (affine-quantified vs wholespace; vanishing vs Hom-finite) is clearly disclosed. Cross-references inside the chapter (and forward to `Cohomology_MayerVietoris.tex` via the §"Foundational parameterised Čech infrastructure" subsection) are intact.
  - Genuinely model chapter for the depth bar the user is asking for: theorem statements that the prover can directly type into Lean, plus paragraph-length proof sketches with named Mathlib API.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Note on file vs directive**: the directive listed this chapter as `Cohomology_MayerVietorisCore.tex / Cohomology_MayerVietorisCover.tex` (two files), but the actual on-disk file is a *single* `Cohomology_MayerVietoris.tex` (1207 lines) that maps to *two* Lean files (`MayerVietorisCore.lean` and `MayerVietorisCover.lean`) plus `BasicOpenCech.lean`. Not a defect, but the directive should be updated next iter to reflect that the blueprint is one consolidated chapter.
  - Vast majority of declarations (~80 numbered blocks) are well-formulated and match their Lean targets. Verified `HModule'_cohomologyPresheaf`, `HModule'_toBiprod`, `HModule'_fromBiprod`, `HModule'_δ`, `HModule'_sequence_exact`, `AffineCoverMVSquare`, `basicOpenCover`, `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`, the `HasCechToHModuleIso` / `HasAffineCechAcyclicCover` typeclass carriers, the four corner identification lemmas (X₁/X₂/X₃/X₄), the basic-open `n`-ary intersection and localisation theorems.
  - **MUST-FIX**: `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` has the most detailed proof sketch in the project (four steps + a four-substep recipe for Step 2), but Remark~\ref{rem:basicOpenCover_step2_status} discloses that the Lean body holds six transient `sorry`s — one of them (Step 2 substep (iv)) is "budget deferral, not Mathlib gap" per the project's accounting. Under the user directive, the "DEFERRED (budget)" annotation is exactly the kind of "temporarily wrong" that the user is forbidding. The proof-engineering work referenced (per-`x` `letI` plumbing for `IsLocalizedModule.pi`) needs a chapter-side decomposition into separate lemmas so the prover has actionable shape, or the deferred substep needs to land.
  - `lem:Scheme_AffineCoverMVSquare_corners` (line 444) is a "summary" lemma with no `\lean{...}` and no `\leanok`. The four single-corner identifications (X₁/X₂/X₃/X₄) immediately following do carry `\lean{...}` hints and are individually formalised. The summary lemma is informational; soon-grade.
  - `def:Abelian_Ext_chgUnivLinearEquiv` (line 631) has no `\leanok` even though all surrounding similar declarations do; the `\lean{...}` hint names `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv` — verify this is a Mathlib-name (the chapter doesn't say so) and add `\mathlibok` if so. Soon-grade.

## Cross-chapter notes

- `Jacobian.tex` `\uses{thm:nonempty_jacobianWitness}` in `def:Jacobian` and `AbelJacobi.tex` `\uses{thm:nonempty_jacobianWitness}` in `thm:exists_unique_ofCurve_comp` — both rely on the same stub. Fixing `thm:nonempty_jacobianWitness` upstream fixes both.
- `Modules_Monoidal.tex`'s `instIsMonoidal_W` is referenced from `Picard_LineBundle.tex` (load-bearing-disclosure paragraph), `Picard_Functor.tex` (§"Post-C1 dependency note"), and `Picard_FunctorAb.tex` (cascading via Pic) — but has no `\label{}` of its own. The downstream `\uses{}` chain cannot point at it; the chapters do so by prose name. Promote it to a numbered theorem with a label before any consumer's `\uses{...}` can cite it formally.
- `Genus.tex` does NOT `\uses{thm:serre_duality_genus}` from `Differentials.tex` even though Genus.tex's "equivalent reformulations" lists `g(C) = dim H^0(Ω_{C/k})` as the dimension-one Serre-duality identity. The cross-reference graph misses an obvious edge.
- `Cohomology_StructureSheafModuleK.tex` §"Use in the project" (line 647) names the discharge route for Phase A step 6 (via `IsAffineHModuleVanishing` + the Čech producer chain in `Cohomology_MayerVietoris.tex`) — but `Genus.tex`'s §"Mathlib gap" does NOT cross-reference this. A prover starting at Genus.tex sees a dead-end "Serre finiteness deferred" without learning the discharge chain exists.
- `AbelJacobi.tex` `def:ofCurve` and `lem:comp_ofCurve` both describe the Pic^0-line-bundle classifying-morphism construction, but the Lean implementation is the Albanese-witness projection. The mismatch is consistent across the two declarations (i.e. the chapter has one mathematical story, and the Lean file has another). The Layer-I/Layer-II split in `Jacobian.tex` is the model for how to disclose this cleanly.
- The directive author's listed file pair `Cohomology_MayerVietorisCore.tex / Cohomology_MayerVietorisCover.tex` does not match the actual on-disk single file `Cohomology_MayerVietoris.tex`. Recommend the planner update the directive next iter; the single-chapter / two-Lean-files split is the current convention.

## Strategy-modifying findings

Under the user directive "no wrong definition/proofs/signatures, never temporarily wrong" the following findings *may* require STRATEGY.md updates rather than mere blueprint-writer dispatches. Naming them so the plan agent can decide.

- **`Jacobian.tex` / `thm:nonempty_jacobianWitness`** — as currently bundled, this theorem absorbs three classically distinct construction routes (Pic^0 representability, Sym^g quotient, Brauer–Severi rigidity) into one existence claim. The blueprint admits Mathlib has none of the three, and the Lean body is `sorry`. The strategy options are:
  - (S1) Keep the bundle, decompose the proof sketch into three subclaims (one per route), and dispatch provers/writers to attack each. The user directive would still consider this "temporarily wrong" until the first route closes.
  - (S2) Contract project scope: drop the four protected Jacobian instances + `def:Jacobian` from the active goal, deferring the entire Jacobian arc to a future project. The Albanese-witness chapter prose stays as forward-looking documentation.
  - (S3) Replace the witness with an axiom-style declaration (formally legal but the user has rejected this elsewhere).

  The choice is a STRATEGY.md decision; the plan agent must update before any prover work on `Jacobian.lean` continues this iter.

- **`Modules_Monoidal.tex` / `instIsMonoidal_W`** — load-bearing across the entire Pic-and-down arc. Same three options apply (decompose, contract scope, or axiomatise). If the user's "no temporarily wrong" applies literally, STRATEGY.md must declare which.

- **`Picard_Functor.tex` / `thm:Pic_representable`** — bypassed at the project level by `nonempty_jacobianWitness`; the simplest fix is scope contraction (remove the theorem from blueprint scope entirely, since no active prover route consumes it). Worth a STRATEGY.md note that this chapter's representability theorem is documentary-only.

- **`Picard_LineBundle.tex` / `thm:SheafOfModules_pullback_tensorObj` + `thm:SheafOfModules_pullback_oneIso`** — paired named-deferred Mathlib gaps that gate `Pic.pullback`. Under "no temporarily wrong" these need either decomposition (hand-construct each iso from the affine-local picture) or strategy contraction.

## Severity summary

Applying the rubric verbatim:

- **must-fix-this-iter** (per the gate rule — any chapter with `complete: partial|false` OR `correct: partial|false`, plus any chapter housing a sorry-bodied protected-route declaration):
  - `Jacobian.tex` — partial/partial. Houses the protected Jacobian-instances chain. **HARD GATE: any prover round on `AlgebraicJacobian/Jacobian.lean` MUST be deferred this iter** until either a blueprint-writer rewrites `thm:nonempty_jacobianWitness` per directive or STRATEGY.md contracts scope.
  - `AbelJacobi.tex` — partial/partial. Houses the protected `ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp` declarations. The `def:ofCurve` mathematical-content drift (Pic^0 prose vs Albanese-projection Lean) is a correctness-grade finding. **HARD GATE: any prover round on `AlgebraicJacobian/AbelJacobi.lean` MUST be deferred** pending the writer rewrite.
  - `Differentials.tex` — partial/partial. `thm:serre_duality_genus` has no proof block; `lem:cotangent_exact_structure` has the deferred `h_exact` case. **HARD GATE: any prover round on `AlgebraicJacobian/Differentials.lean` MUST be deferred** until a writer fills `thm:serre_duality_genus` with at least a paragraph-length proof sketch.
  - `Modules_Monoidal.tex` — partial/partial. `instIsMonoidal_W` has no numbered theorem with a `\lean{...}` hint and is load-bearing across Pic-and-down. **HARD GATE: any prover round on `AlgebraicJacobian/Modules/Monoidal.lean` MUST be deferred** pending a writer who promotes `instIsMonoidal_W` to a numbered theorem (with the proof-sketch prose moved into a `\begin{proof}` block).
  - `Picard_LineBundle.tex` — partial/true (correct but incomplete in the user-directive sense). `thm:SheafOfModules_pullback_tensorObj` and `thm:SheafOfModules_pullback_oneIso` are bare named-deferred-gap stubs. **HARD GATE: any prover round on `AlgebraicJacobian/Picard/LineBundle.lean` that touches either iso MUST be deferred**.
  - `Picard_Functor.tex` — partial/partial. `thm:Pic_representable` is a one-liner pointing at FGA. **HARD GATE: any prover round on `AlgebraicJacobian/Picard/Functor.lean` that touches `representable` MUST be deferred** (the rest of the file, `PicardFunctor` + `quotMap`, is unaffected).
  - `Cohomology_MayerVietoris.tex` — partial/partial. `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` has six labelled transient sorries including the "budget-deferred" Step 2 substep. **HARD GATE: any prover round on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` MUST be deferred** until a writer either decomposes the Step 2 substep into a separate auxiliary lemma or STRATEGY.md re-permits the budget-deferred substep.
  - `Genus.tex` — partial/true. Discharge-chain cross-reference missing. Less severe (definition itself is correct and matches the Lean file), but per the gate rule any partial chapter blocks its file. **The Lean file `AlgebraicJacobian/Genus.lean` has only 1 sorry (in a comment); the chapter rewrite needed is small (add `\uses{thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf}` and a one-paragraph discharge-chain remark). The gate still applies.**

- **soon**:
  - `Cohomology_SheafCompose.tex` proof depth (informational-grade).
  - `Cohomology_StructureSheafAb.tex` proof depth ("inferable; universe-pin" without naming Mathlib API).
  - `Cohomology_StructureSheafModuleK.tex` minor `\mathlibok` / `\lean{...}`-hint cleanups (only if user wants the entire blueprint at the depth bar above).
  - `Picard_FunctorAb.tex` `etaleSheafified` proof depth.
  - `Rigidity.tex` §"Use in the project" classical-vs-formal uniqueness wording (informational).

- **informational**:
  - Directive's file-name pair (`MayerVietorisCore / MayerVietorisCover`) doesn't match the on-disk single file (`MayerVietoris.tex`). Update directive next iter.
  - `Cohomology_MayerVietoris.tex` `def:Abelian_Ext_chgUnivLinearEquiv` missing `\leanok`/`\mathlibok`.
  - `lem:Scheme_AffineCoverMVSquare_corners` is a summary lemma with no `\lean{...}` — fine but worth noting.

**Overall verdict**: The blueprint is rich and largely well-formed, but the user directive ("no temporarily wrong; sufficient detail for provers") fires must-fix on 8 of 13 chapters, predominantly around named-Mathlib-gap stubs (`nonempty_jacobianWitness`, `instIsMonoidal_W`, the `pullback_tensorObj`/`oneIso` pair, `Pic_representable`, `serre_duality_genus`, `cotangentExactSeq_structure.h_exact`, the `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` transient sorries) and the `def:ofCurve` Pic^0-vs-Albanese mathematical-content drift in `AbelJacobi.tex` — every active prover route on a `.lean` file under the Phase A / Jacobian / AbelJacobi / Modules-Monoidal / Picard-LineBundle / Picard-Functor / Differentials surface should be deferred this iter pending blueprint-writer dispatches that either decompose the stubs into actionable subclaims or trigger STRATEGY.md scope contractions.
