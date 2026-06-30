# Analogy: composite-adjunction-unit cocycle across a sheafification∘pullback boundary — discharge it the way the project ALREADY discharges its bare-adjunction twin

## Mode
cross-domain-inspiration

## Slug
d3-mate-306

## Iteration
306

## Structural problem (abstracted)
A comparison 2-cell `c_φ : a∘L₁(φ) ≅ L₂(φ)∘a` for a base-change 1-cell `φ`, where `a` is a
reflective-localization functor (sheafification) and `L₁,L₂` are the left adjoints of two
pseudofunctors (presheaf-pullback, sheaf-pullback). Each `c_φ` is `leftAdjointUniq` of two COMPOSITE
adjunctions `B_φ, A_φ` that share the **same right adjoint** `R_φ` (because `forget∘pushforward^sheaf
= forget∘pushforward^presheaf` on the nose). Needed: the "respects composition of 1-cells" cocycle
`c_{h≫f} = (pullbackComp h f).inv ≫ pullback(h)·c_f ≫ c_h ≫ a·(presheaf pullbackComp).hom`. In mate
language: the conjugate of `c_φ` on the shared right adjoint is the IDENTITY, so the whole cocycle
should transpose to a coherence among the two `pushforwardComp` pseudofunctor isos, which are STRICT
(`pushforwardComp_inv_app_app = 𝟙`).

## Failed approaches (from directive)
- Direct transpose of the whole TAIL eq (`homEquiv` both sides): circular (unknown on both sides).
- Sectionwise `hom_ext; intro U; rfl`: sheafification unit not sectionwise trivial.
- `(a)–(e)` paste assembly: blocks on a named presheaf↔sheaf bridge (≥5 iters).
- `conjugateEquiv_whiskerLeft` / `leftAdjointCompNatTrans_assoc` (prior analogist): gave a `homEquiv`
  head but did not close — applied at the TAIL fragment, not the whole equation.

## Analogues found

### Analogue: project-local `gr_pullbackObjUnitToUnit_comp` (`AlgebraicJacobian/Picard/GlueDescent.lean:408`) — the SAME cocycle one functor down, already SOLVED, axiom-clean  ← TOP
- **Domain**: the project's own bare-`pullback`/`pushforward` (Scheme.Modules) layer — the
  sheafification-free twin of the exact obstruction.
- **Same structural problem there**: the pseudofunctor `map_comp` cocycle for the unit comparison
  `pullbackObjUnitToUnit` across `b≫a` — identical shape to `sheafificationCompPullback_comp`, minus
  the sheafification layer. Verified `sorry`-free (lines 408–479).
- **Technique** (the WHOLE recipe, which AVOIDS the circularity blocking the tail):
  1. `apply ((pbPush a).comp (pbPush b)).homEquiv _ _ |>.injective` — transpose the **whole**
     equation under the composite adjunction (NOT a fragment).
  2. `homEquiv_conjugateEquiv_app` (project, `GlueDescent.lean:367`) collapses the LHS in **term
     mode (`.trans`)** keeping `pullbackComp` OPAQUE — this is the anti-circularity move: the unknown
     is never re-introduced via `rw`/`homEquiv_leftAdjointUniq_hom_app`.
  3. `conjugateEquiv_comm` + `Scheme.Modules.conjugateEquiv_pullbackComp_inv` (Mathlib
     `PullbackContinuous.lean:176`) identify `conjugate(pullbackComp.hom) = pushforwardComp.inv`.
  4. RHS via `Adjunction.comp_homEquiv` + `homEquiv_naturality_left/right` + the named transpose
     bridge (`…_homEquiv_pullbackObjUnitToUnit`).
  5. Land on the STRICT section identity `pushforwardComp_inv_app_app = 𝟙` via `rfl` (`hMid`).
- **Mapping to project**: re-prove `sheafificationCompPullback_comp` (`TensorObjSubstrate.lean:2705`)
  END-TO-END mirroring this, and DELETE/inline `sheafificationCompPullback_comp_tail` (the fragment
  is the source of the circularity). Differences to budget: (i) the LHS transpose of
  `sheafificationCompPullback.hom = leftAdjointUniq.hom` is the composite unit `B.unit` (already known
  via `homEquiv_leftAdjointUniq_hom_app` / `leftAdjointUniqUnitEta_app`); BUT keep RHS `pullbackComp`
  factors opaque with `homEquiv_conjugateEquiv_app` instead of manually peeling R0. (ii) TWO
  pullbackComp factors: sheaf `pullbackComp h f` → `Scheme.Modules.conjugateEquiv_pullbackComp_inv`;
  presheaf `pullbackComp φ'_f φ'_h` → the abstract `Adjunction.conjugateEquiv_leftAdjointCompIso_inv`
  (`CompositionIso.lean:82`, no project-named presheaf version). (iii) sheafification layer is FREE:
  the conjugate of `leftAdjointUniq.hom` on the shared right adjoint is `Iso.refl` (`Unique.lean:36`,
  `unit_leftAdjointUniq_hom_app:51`), so it contributes an identity, not a contaminating unit.
- **Porting cost**: low–medium. The entire device set (`homEquiv_conjugateEquiv_app`,
  `conjugateEquiv_comm`, `conjugateEquiv_pullbackComp_inv`, `comp_homEquiv`) already exists and is
  proven in-project; this is a structural re-org of a half-finished proof, not new infrastructure.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `mateEquiv_vcomp` / `mateEquiv_hcomp` / `mateEquiv_square` (`Mathlib/CategoryTheory/Adjunction/Mates.lean:167, 206, 242`) — the bicategorical double-category coherence the project has been hand-rolling
- **Domain**: pure category theory — the mate calculus as a morphism of double categories.
- **Same structural problem there**: "the mate of a PASTING of squares = the PASTING of mates",
  with the adjunctions on each side allowed to be `.comp`s. `mateEquiv_vcomp`: `mateEquiv adj₁ adj₃
  (α ≫ₕ β) = mateEquiv adj₁ adj₂ α ≫ᵥ mateEquiv adj₂ adj₃ β` (DIFFERENT adjunctions top/mid/bottom —
  unlike `conjugateEquiv`). `mateEquiv_hcomp`: handles `.comp` adjunctions (exactly the
  sheafify∘pullback composites). `mateEquiv_square`: "squares of squares" — the abstract statement of
  the FOUR-square interleaved paste `pullbackTensorMap_restrict` needs.
- **Technique**: `unfold hComp vComp mateEquiv; ext; simp [unit_naturality, counit.naturality,
  left/right_triangle_components]` — slide each square's naturality + the adjunction triangles past
  the pasting. The right-adjoint side does all the work; when that side is STRICT (project: the
  forget/pushforward commuting square is identity), the RHS pasting collapses.
- **Mapping to project**: NONE of the prior analogist reports (d3-mate271, ma-d3264) mention the
  `mateEquiv_*comp` family — they used only `conjugateEquiv` (the identical-vertical-functors special
  case) and ad-hoc whiskering, which forces manual re-derivation of what `mateEquiv_vcomp`/`_square`
  already prove. `sheafificationCompPullback_comp` is `mateEquiv_vcomp` of two naturality squares with
  a strict right side; the parent `pullbackTensorMap_restrict` paste is `mateEquiv_square`. Re-express
  `sheafificationCompPullback` via `mateEquiv`/`TwoSquare` and the pullbackComp's as
  vertical/horizontal composites. NB `mateEquiv` does NOT preserve isos (Mates.lean:79) — irrelevant
  here since the cocycle is an equation between already-known isos at the `.hom`/natTrans level.
- **Porting cost**: medium–high. Requires recasting the comparison as a `TwoSquare` and the coherence
  data as `≫ᵥ`/`≫ₕ` composites — a bigger restructure than Analogue 1, but the canonical bicategorical
  route and the one that scales to the full four-square paste.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: Mathlib `SheafOfModules.pullback_assoc` (`PullbackContinuous.lean:192`) + `sheafificationCompPullback` def (`:117`) — confirms the gap, gives the strict-right-side template
- **Domain**: algebraic geometry / category theory — Mathlib's own sheaf-pullback pseudofunctor.
- **Same structural problem there**: `pullback_assoc` is the SIBLING cocycle, discharged by
  `leftAdjointCompIso_assoc` (`CompositionIso.lean:168`) reducing to `pushforward_assoc` (strict
  right side). And Mathlib BUILT the exact bridge `sheafificationCompPullback`/`pullbackIso`
  (`:117, :105`) but proved NO composition coherence for it (grep returns only the `def`).
- **Technique**: `ext; exact leftAdjointCompNatTrans_assoc … (right-side coherence)`; the engine
  `leftAdjointCompNatTrans_assoc` (`:155`) reduces via `obtain ⟨τ,rfl⟩ := (conjugateEquiv …).surjective;
  apply (conjugateEquiv …).injective; simp [conjugateEquiv_comp, conjugateEquiv_whisker*]`.
- **Mapping to project**: confirms NEEDS_GAP_FILL — there is no drop-in. CRITICALLY this is the
  prior-FAILED `leftAdjointCompNatTrans_assoc` route: it is `leftAdjointCompIso` (composition WITHIN
  one pseudofunctor), but `sheafificationCompPullback` is `leftAdjointUniq` (a BRIDGE between two
  pseudofunctors), so it is not an instance. Do NOT re-try it at the tail-fragment level (that is
  what failed). Use it only as confirmation that the strict-right-side reduction is the correct shape
  — which Analogue 1 realizes via the project's working `gr_pullbackObjUnitToUnit_comp` template.
- **Porting cost**: high as a direct route (not an instance); zero as confirmation.
- **Verdict**: PARTIAL_ANALOGUE.

## Top suggestion
Stop working the TAIL. Re-prove `sheafificationCompPullback_comp` (`TensorObjSubstrate.lean:2705`)
end-to-end by **porting the project's own `gr_pullbackObjUnitToUnit_comp` (`GlueDescent.lean:408–479`)
one composite-adjunction level up**, and inline/delete `sheafificationCompPullback_comp_tail`. Read
first: `GlueDescent.lean:367` (`homEquiv_conjugateEquiv_app`) and `:408–479` (the full template), then
`Unique.lean:36–61` (`leftAdjointUniq` = conjugate-of-identity ⇒ the sheafification layer transposes
to `Iso.refl`, the reason the unit never contaminates). The anti-circularity pivot is step 2: collapse
the transposed LHS with `homEquiv_conjugateEquiv_app` in **term mode**, keeping BOTH `pullbackComp`
factors opaque, then kill their conjugates with `Scheme.Modules.conjugateEquiv_pullbackComp_inv`
(sheaf) and `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` (presheaf, `CompositionIso.lean:82`),
landing on the strict `pushforwardComp_inv_app_app = 𝟙` `rfl`. If this proves fiddly at the four-square
parent `pullbackTensorMap_restrict`, escalate to `mateEquiv_square` (`Mates.lean:242`) as the abstract
paste. First project file to touch: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2705`.

## Discarded
- `Adjunction.leftAdjointUniq_trans` (`Unique.lean:79`): requires SAME right adjoint across f/h/h≫f;
  the three comparisons have different right adjoints conjugated by pullbackComp. (Noted ma-d3264.)
- `Adjunction.localization` / `localization_unit_app` (Localization/Adjunction.lean): structural
  model only — project built `B_φ` as `Adjunction.comp`, not `Adjunction.localization`; high cost,
  already PARTIAL in d3-mate271.
- Re-trying `leftAdjointCompNatTrans_assoc` / `conjugateEquiv_whiskerLeft` at the tail: directive's
  failed-approaches; the issue was granularity, addressed by Analogue 1's whole-equation reshape.
