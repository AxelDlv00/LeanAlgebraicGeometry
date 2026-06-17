# Blueprint Review Report

## Slug
iter110

## Iteration
110

## Top-level summaries

### Incomplete parts
- `Picard_LineBundle.tex`: no theorem/definition block for `SheafOfModules.pullback_oneIso` exists. The Lean side (`AlgebraicJacobian/Picard/LineBundle.lean:96`) introduces a *second* named-deferred oracle, the unit-preservation iso `(pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules`, sibling to `pullback_tensorObj`. The post-C1 body of `Pic.pullback` consumes both oracles in lockstep, but the blueprint records only `pullback_tensorObj` (Theorem `\thm:SheafOfModules_pullback_tensorObj`). Closure requires a sibling theorem block (statement + `\lean{AlgebraicGeometry.Scheme.SheafOfModules.pullback_oneIso}` + 1-paragraph proof block + remark documenting that both oracles collapse together under a future Mathlib `(SheafOfModules.pullback _).Monoidal`).

### Proofs lacking detail
- `Picard_LineBundle.tex` / `\thm:Scheme_Pic_pullback` proof block (L77–82): the prose says "$f^* = \mathrm{Units.map}(\mathrm{Skeleton.monoidHom}(\mathrm{Scheme.Modules.pullback}\,f))$" and frames this as the "eventual Lean definition" pending a `Functor.Monoidal` instance. This contradicts the actual iter-109 body, which hand-builds the underlying monoid hom via `(Scheme.Modules.pullback f).mapSkeleton` routed through `pullback_oneIso` (for `map_one'`) and `pullback_tensorObj` (for `map_mul'`). The prose hides the fact that the body has already chosen the hand-construction route over the `Skeleton.monoidHom` route, and that both oracles are *currently* consumed (not "eventually").
- `Differentials.tex` / `\thm:smooth_iff_locally_free_omega` (L160): one-sentence proof sketch ("The forward direction is the Jacobian criterion; the converse follows from the cotangent exact sequence and Nakayama's lemma applied at each point") is not enough for a prover to formalize. The Jacobian criterion in Lean is `Algebra.smooth_iff_jacobian` (or a sibling); the converse uses Nakayama-graded-from-cotangent. Neither side names the load-bearing Mathlib lemma, and the prover would have to guess the API entry point. With the variance-flagged Serre duality (L877) parked, this is the next prover-route target — it needs at least the Mathlib lemma names and a one-paragraph local-to-global gluing sketch.
- `Differentials.tex` / `\cor:cotangent_at_section` (L163–169): no proof block at all; the prose names the conclusion but provides no derivation from `\thm:smooth_iff_locally_free_omega`. A prover would have to infer the pullback-along-section step (specifically that locally-free-of-rank-$n$ is preserved under pullback) without reference to the underlying API.
- `Differentials.tex` / `\thm:relative_kaehler_isSheaf` (L20–26): the proof sketch reduces to "the localisation compatibility $\Omega_{B[1/f]/A} \cong \Omega_{B/A} \otimes_B B[1/f]$; descent from a basis to all opens is standard." This collapses the bulk of the work into "standard": the prover needs (i) the Mathlib name for the localisation compatibility (e.g. `KaehlerDifferential.tensorKaehlerEquiv` or sibling), and (ii) the basis→opens descent recipe — neither is supplied.

### Lean difficulty quality
- (no chapter has poor `\lean{...}` formulation that is part of an active prover route; the `\lean{...}` targets named in Differentials.tex for L122/L718/L735 match the actual decls)

### Multi-route coverage
- Single end-to-end route per directive: PASS — covered across all 13 chapters with no orphaned routes. Phase A (Čech acyclicity), Phase B (Differentials), Phase C0/C1 (Monoidal, LineBundle), Phase C2 (Functor, FunctorAb), Phase C3 (representability deferred via Jacobian's `nonempty_jacobianWitness` exit policy), Genus/AbelJacobi/Rigidity helpers all anchored.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp` consistent with `Jacobian.tex` Albanese exit policy. No issues.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - L1196 vs L1167–1176 substep numbering inconsistency: L1167–1176 introduces substeps (i)=Image-Finset bridge, (ii)=Restriction-of-section, (iii)=Per-coord `IsLocalization.Away`, (iv)=Finite-product localization lift. L1196 then attributes "the inclusion $V_x \subseteq U$ and the restriction-of-section identity" to "(i) and (ii)" and "the image-Finset bridge and the per-coord `IsLocalization.Away` certificate" to "(iii)". This shifts the substep labels by one slot relative to the enumeration above. Cosmetic but a real source of reader confusion.
  - L1198 "the project's enumerated Mathlib-gap list (`instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`)" is the 3-tuple flagged in the directive; post-iter-109 the surface is 6 named-gap sorries (the three listed plus `PicardFunctor.representable`, `pullback_tensorObj`, `pullback_oneIso`) + 1 budget-deferral. Update needed.
  - Directive flags "missing `IsLocalizedModule.prodMap` mention". L1176 currently mentions `IsLocalizedModule.pi` and the `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` adapter. If the actual mechanization route post-iter-109 routes through `IsLocalizedModule.prodMap` (per the directive), the recipe text needs a `prodMap` mention added or substituted. (Cosmetic, but it changes which Mathlib lemma a future prover will reach for.)
  - Substantive declarations (the Mayer–Vietoris LES, the Čech acyclicity theorem, the consumer chain into `IsAffineHModuleVanishing` and the basic-open infrastructure) are all in place and correct against the directive's "off-limits BasicOpenCech sub-routes" constraint. The remaining transient sorries inside `BasicOpenCech.lean` are properly documented in Remark `rem:basicOpenCover_step2_status`.

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
- **notes**: -

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Per directive focus: the chapter is on the cusp of becoming an active prover-route, with L122 (`relativeDifferentialsPresheaf_isSheaf`), L718 (`smooth_iff_locally_free_omega`), L735 (`cotangent_at_section`) as the prover-viable targets (L877 `serre_duality_genus` variance-flagged and parked per directive).
  - `\thm:relative_kaehler_isSheaf` (corresponding to L122): proof sketch is shallow — see "Proofs lacking detail" above.
  - `\thm:smooth_iff_locally_free_omega` (corresponding to L718): one-sentence proof is too compressed for a prover to formalize without naming the Mathlib entry points — see "Proofs lacking detail".
  - `\cor:cotangent_at_section` (corresponding to L735): no proof block at all — see "Proofs lacking detail".
  - The `lem:cotangent_exact_structure` block is correctly disclosed as "deferred parallel to `instIsMonoidal_W`" with both blocked routes (stalkwise via `SheafOfModules.stalkFunctor`; sectionwise via `ShortComplex.exact_map_iff_of_faithful`) enumerated. This block is in good shape post-iter-109.
  - The non-formalised stalk-detection lemma `lem:sheafOfModules_exact_iff_stalkwise` (L105–108) is documented correctly with no `\lean{...}` hint.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**: C3 exit policy via `nonempty_jacobianWitness` documented correctly (directive: final, not re-litigated).

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**: Load-bearing disclosure for `instIsMonoidal_W` is in place (`rem:W_IsMonoidal_load_bearing`). Post-C1 status is correctly captured. The split into definition / monoidal / braided / invertible-objects mirrors the Lean file shape.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Stale prose at L84 in the "Post-C1 dependency note": "The Lean body of `Pic.pullback` (`AlgebraicJacobian/Picard/LineBundle.lean:93`) is currently `sorry`, pending closure of (or a hand-construction equivalent to) Theorem `thm:SheafOfModules_pullback_tensorObj`." Post-iter-109 the Lean body is *filled* — `Pic.pullback` is hand-built from the two oracles `pullback_oneIso` and `pullback_tensorObj`. The dependency is transitive on both oracles, not on the body itself.
  - L84 continues: "The functoriality lemmas `Pic.pullback_id` and `Pic.pullback_comp` (`Picard/LineBundle.lean:99,\,105`) are likewise sorry-bodied for the same reason." Both bodies are filled in iter-109 and only `Pic.pullback`'s `mapSkeleton.obj` underlying iso (through `Scheme.Modules.pullbackId`/`pullbackComp`) is used — they are *not* sorry-bodied. Line numbers (93, 99, 105) are also stale.
  - Closer to the truth: "The Lean bodies of `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` are filled in iter-109 by hand-construction through `(Scheme.Modules.pullback f).mapSkeleton`; the `map_one'`/`map_mul'` proof obligations transitively consume the two named-deferred oracles `SheafOfModules.pullback_oneIso` and `SheafOfModules.pullback_tensorObj`. Only `Pic.pullback_id`/`_comp` themselves typecheck without any oracle (they use Mathlib's `pullbackId`/`pullbackComp`)."
  - The "Inherited (post-C1) from Chapter Picard_LineBundle" bullet at L74 mentions only `pullback_tensorObj`; should be updated to record the inheritance of *both* oracles (`pullback_tensorObj` and `pullback_oneIso`).
  - The L43 prose inside the `thm:Pic_representable` proof's step-C2 description correctly notes the post-C1 universe simplification (PicardFunctor lands in `Type (u+1)`, PicardFunctorAb in `AddCommGrpCat.{u+1}`). This is correct (verify via Lean). However, this directly contradicts Picard_FunctorAb.tex (see cross-chapter note below).

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - L66 and L73 say `PicardFunctorAb` lands at `AddCommGrpCat.{u}` and that the etale-sheafification body must "post-compose with the natural universe lift `AddCommGrpCat.{u} → AddCommGrpCat.{u+1}`". This contradicts Picard_Functor.tex L43 which says: "post-C1, `PicardFunctorAb` already lands in `AddCommGrpCat.{u+1}`, so the universe-lift is unnecessary and the body simplifies by one functor composition." One of the two chapters is stale. (See Cross-chapter notes.)

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Missing block for `SheafOfModules.pullback_oneIso`** — see "Incomplete parts". This is the directive's explicit ask ("the blueprint should record `pullback_oneIso` as a sibling theorem block to `pullback_tensorObj`").
  - **Stale "remain `sorry`" prose at L62 and L81** (the `% NOTE` at L62, and the closing sentence of the `\thm:Scheme_Pic_pullback` proof at L81). Both assert the three Pic.pullback bodies are sorry. Post-iter-109 the three bodies are filled; only the two oracles remain sorry.
  - **Stale `Skeleton.monoidHom` framing at L77–81** of the `\thm:Scheme_Pic_pullback` proof. The prose describes the eventual Lean body as `Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))`, contingent on a future Mathlib `Functor.Monoidal` instance. The iter-109 body actually uses `(Scheme.Modules.pullback f).mapSkeleton.obj` with a hand-built `MonoidHom`, where `map_one'` invokes `pullback_oneIso` and `map_mul'` invokes `pullback_tensorObj`. The prose should be updated to reflect the hand-construction route taken, mentioning the `mapSkeleton`-based body and both oracles as the closure surface.
  - The definitions of `LineBundle X = (Skeleton X.Modules)ˣ`, the `instCommGroupLineBundle`, the load-bearing disclosure paragraph for `instIsMonoidal_W` (L24–25), and the named-deferred routing of `pullback_tensorObj` are all in place and consistent with the directive's "C1 promotion is final, do not re-litigate" constraint.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**: -

## Cross-chapter notes

- **Universe-lift inconsistency between `Picard_Functor.tex` L43 and `Picard_FunctorAb.tex` L66/L73**. The Functor chapter says post-C1 the universe-lift is unnecessary because `PicardFunctorAb` lands in `AddCommGrpCat.{u+1}`. The FunctorAb chapter still describes the universe-lift composition as part of the etale-sheafification body. Only one can be true. Action: pick the correct version (most likely the Functor chapter's L43 statement that the universe-lift is gone, given iter-109's universe-bump narrative in Modules_Monoidal.tex and Picard_LineBundle.tex), and revise the FunctorAb chapter's L66/L73 to match. The `\lean{...}` hint `\lean{AlgebraicGeometry.Scheme.PicardFunctorAb.etaleSheafified}` does not itself disambiguate — the prover would need to read the Lean signature to know the truth.

- **`SheafOfModules.pullback_oneIso` is not surfaced in Picard_Functor.tex's "inherited gap" bullet**. The L74 bullet records only `pullback_tensorObj` as the inherited gap; post-iter-109 both oracles are inherited (the Lean `Pic.pullback` body consumes both, and consumers transitively consume both). This is a cross-chapter coherence issue: Picard_LineBundle.tex needs the new theorem block (see above), and Picard_Functor.tex's inheritance list needs to mention both.

- **Picard_Functor.tex's `\uses{}` of `thm:SheafOfModules_pullback_tensorObj`** in the `\thm:Pic_representable` proof block (L38) does not include the new sibling `pullback_oneIso`. After the new theorem block is added in Picard_LineBundle.tex, this `\uses{}` should be updated to include both oracles (otherwise the dependency-graph reading of "this representability theorem depends on the closure of the C1 oracles" is incomplete).

## Strategy-modifying findings (if any)

(none)

## Severity summary

- **must-fix-this-iter**:
  - **`Picard_LineBundle.tex`** is `complete: partial` AND `correct: partial`. The missing `pullback_oneIso` block + stale "remain sorry" prose + stale `Skeleton.monoidHom` framing must be repaired this iter. Per directive, the C1 promotion landed iter-109 and is final, but the *blueprint* must catch up to the Lean state.
  - **`Picard_Functor.tex`** is `correct: partial`. The L84 stale-sorry prose mis-describes the post-iter-109 state of `Pic.pullback`/`_id`/`_comp` and the L74 inherited-gap bullet underreports the oracle surface.
  - **`Picard_FunctorAb.tex`** is `correct: partial`. L66 and L73 directly contradict Picard_Functor.tex's L43 post-C1 universe-lift simplification — exactly one of the two chapters is stale, and the FunctorAb chapter is the most likely culprit.
  - **`Differentials.tex`** is `complete: partial`. The directive asked whether the chapter is adequate for a prover round on L122 / L718 / L735 *without* triggering the L877 variance flag. The answer is: not yet — three of the four prover-viable targets (`relative_kaehler_isSheaf`, `smooth_iff_locally_free_omega`, `cotangent_at_section`) lack proof detail at the level a prover can mechanize. The L877 `serre_duality_genus` variance flag is well-known and parked, but the other three need writer attention before a prover round on Differentials.lean is dispatched.
  - **`Cohomology_MayerVietoris.tex`** is `complete: partial` AND `correct: partial`. The stale 3-tuple Mathlib-gap-list at L1198 leaks an outdated count into a load-bearing remark, and the L1196 substep numbering is off-by-one against L1167–1176. The directive flagged this as MINOR but the project-wide gap surface is now 6+1, not 3+1; the discrepancy belongs in the must-fix bucket because future readers will trust this remark's enumeration.

- **soon**:
  - None.

- **informational**:
  - The `IsLocalizedModule.prodMap` mention in Cohomology_MayerVietoris.tex L1176 is cosmetic and only matters if the actual iter-109 mechanization plan threads through `prodMap` rather than `pi` (verify against the canonical recipe before fixing).
  - The `\uses{}` graphs in `Picard_Functor.tex` proof of `\thm:Pic_representable` and other downstream consumers may benefit from a sweep to mention the new `pullback_oneIso` once the block is added. Not blocking.

**Overall verdict**: Five chapters must be touched by a `blueprint-writer` this iter (Picard_LineBundle, Picard_Functor, Picard_FunctorAb, Differentials, Cohomology_MayerVietoris); the C1 promotion is mathematically final, but the blueprint prose lags the Lean state in the post-iter-109 line.
