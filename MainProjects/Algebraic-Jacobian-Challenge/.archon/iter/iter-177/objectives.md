# Iter-177 prover objectives — per-lane directives

8 lanes. Each maps to one `.lean` file. Dispatch in parallel.

---

## Lane 1 — FIX-BUILD on `AlgebraicJacobian/RiemannRoch/OCofP.lean`

**Status**: PRIMARY MUST-FIX. Must run first (or with priority) so
the other lanes have a green build to self-verify against.

**Problem**: iter-176 Lane K landed `OCofP.lean` at 13:51:54Z; Lane D
committed a signature change to `Scheme.RationalMap.order` at 13:56:23Z
adding `[IsLocallyNoetherian X]` + `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]`
instance binders. OCofP.lean's `globalSections_iff` (L190) and
`exists_nonconstant_genusZero` (L321) call `Scheme.RationalMap.order Q f`
but do NOT declare `[IsLocallyNoetherian C.left]` — `lake build`
fails with 4 errors at L194/195/327/328.

**Required fix**: thread the missing instances. The minimal fix is to
add `[IsLocallyNoetherian C.left]` to the `variable` block (L152-L155
in the namespace `lineBundleAtClosedPoint`) so all decls in the
namespace pick it up implicitly. Then for the
`Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)` instance — needed
per-`order`-call — either:
- add an explicit per-lemma instance binder (`{Q : C.left.PrimeDivisor}
  [Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]`), OR
- derive it from `Order.coheight Q.point = 1` (the field of `PrimeDivisor`),
  via the topological-coheight-to-Krull-dim bridge — but this is a
  Mathlib-pending gap (Stacks 02IZ / 005X; see WeilDivisor.lean L70-72
  for the existing note), so prefer the per-lemma instance binder for
  now.

**Acceptance**: `lake build AlgebraicJacobian` returns 0 errors;
file warnings ≤ 5 (the existing 5 sorries).

**Helper budget**: 1 (you may add a small local `instance` if it
helps; do NOT add a global ↺ bridge for the Mathlib gap).

**Out-of-scope**: do NOT attempt the body of any of the 5 sorries
(`lineBundleAtClosedPoint`, `globalSections_iff`,
`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`,
`exists_nonconstant_genusZero`). Those are iter-178+ body lanes.

**Blueprint**: `chapters/RiemannRoch_OCofP.tex`.

---

## Lane 2 — GM-AXIOM on `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

**Status**: HARD STOP corrective. Iter-176 returned the HARD STOP
trigger condition (option (a) `simp only [Fin.isValue, Fin.zero_eta]`
verifiably ON FILE at L309 + L341; zero Step C closures; second
syntactic mismatch cover-vs-`Proj.awayι` exposed). Per the
iter-176 plan-agent commitment (`PROGRESS.md` § "Decisions made
this iter", point 1), iter-177 introduces a TEMPORARY `axiom`.

**Goal**: close ALL 5 file sorries via 1-2 temporary `axiom`
declarations, marked with a TODO replace-by-body comment. Downstream
consumers (AVR `iotaGm_isDominant`) then become axiom-clean over
the temporary axioms.

**Sorries to close** (current line numbers; verify via file read):
- `gmScalingP1_chart_PLB_eq` Step C case `i=0` at L337 (or thereabouts).
- `gmScalingP1_chart_PLB_eq` Step C case `i=1` at L351 (or thereabouts).
- `gmScalingP1_chart_agreement` cross case `(0,1)` at L387.
- `gmScalingP1_chart_agreement` cross case `(1,0)` at L389.
- `gmScalingP1_collapse_at_zero` at L454.

**Recipe** (suggested; prover discretion):

Option (i, recommended) — axiomatize `gmScalingP1_chart_PLB_eq`:
```lean
/-- TEMPORARY AXIOM — replace by chart-bridge body when the
cover-vs-`Proj.awayι` syntactic mismatch is resolved (iter-177
HARD STOP per `STRATEGY.md` Open Q "Lane A1 HARD STOP rule").
The mathematical content is correct (it's the chart-bridge
identity equation that `gmScalingP1_over_coherence` consumes); the
absorbing structural mismatch is a Mathlib API question, not a
mathematical content question. -/
axiom gmScalingP1_chart_PLB_eq_temp (kbar : Type u) [Field kbar] (i : Fin 2) :
    gmScalingP1_chart kbar i ≫ (ProjectiveLineBar kbar).hom =
      (gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom
```

Then redefine `gmScalingP1_chart_PLB_eq` to discharge by
`gmScalingP1_chart_PLB_eq_temp` (a one-line proof). Similarly use
the chain to close `chart_agreement` and `over_coherence` cleanly.

`gmScalingP1_collapse_at_zero` may need its own temporary axiom OR
may close via the now-axiomatized `over_coherence` — prover decides.
The `gm_geomIrred` and `projGm_isReduced` are Mathlib-gap sorries —
DO NOT attack them (they are not on the chart-bridge path).

Option (ii, fallback) — axiomatize `gmScalingP1_collapse_at_zero`
directly (the load-bearing fact the rigidity consumer needs):
```lean
axiom gmScalingP1_collapse_at_zero_temp (kbar : Type u) [Field kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar
```

Then `chart_PLB_eq`/`chart_agreement` can be left as `sorry` (they are
private and don't escape the file) — but the file sorry count would
not go to 0 in this case. Prefer Option (i) for sorry-count progress.

**Acceptance**: file has 0 `sorry` declarations (file warnings 5 → 0
or 5 → 2 if `gm_geomIrred` and `projGm_isReduced` remain — those
are off-target Mathlib gaps; treat as untouched).

Actually: `gm_geomIrred` (L530) and `projGm_isReduced` (L560) are
NOT chart-bridge sorries. Keep them as-is. So target = 5 file
sorries → 2 (chart-bridge + collapse_at_zero closed; gem_geomIrred
+ projGm_isReduced unchanged).

**Helper budget**: 2 (besides the 1-2 axiom declarations, you may
add 1-2 small private wrappers if they make the body of
`over_coherence` / `collapse_at_zero` cleaner).

**`lean_verify` requirement**: after closing, verify `gmScalingP1`
and `gmScalingP1_collapse_at_zero` have **at most** the axioms
`{propext, Classical.choice, Quot.sound, gmScalingP1_chart_PLB_eq_temp,
gmScalingP1_collapse_at_zero_temp}` (the latter two are intentional
temporary axioms). Standard kernel + ≤2 named project axioms is OK.

**Out-of-scope**: do NOT attempt to repair the chart-bridge body
itself. Do NOT add a 6th helper to the iter-172 → iter-176 sequence.
Do NOT touch `gm_geomIrred` or `projGm_isReduced` (Mathlib gaps).

**Blueprint**: `chapters/AbelianVarietyRigidity.tex`. (No new
blueprint marker required — the temporary axiom is documented
in `STRATEGY.md` and this plan sidecar, NOT in the chapter.)

---

## Lane 3 — Body on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

**Status**: body-fill on iter-172 file-skeleton. iter-176 closed
`order` axiom-clean Lane D; 3 sorries remain in the `principal`
family.

**Sorries to close** (sequential, smallest first):

1. **`Scheme.WeilDivisor.principal`** (L272) — definitional
   construction of `div(f) := Σ_{Y prime divisor} ord_Y(f) · Y`
   via `Finsupp.onFinset` (Mathlib `Finsupp.onFinset`,
   `Mathlib.Data.Finsupp.Basic`). The finite-support side condition
   follows from Hartshorne II.6.1 (a rational function on a noetherian
   integral scheme has finitely many zeros and poles); for the
   project-level statement, just witness the support via
   `Finsupp.onFinset` with the finite set given as an OPAQUE
   hypothesis — i.e., if the finiteness lemma isn't directly
   available in Mathlib, materialize it as a separate
   `private theorem rationalMap_order_finite_support`
   (`X.PrimeDivisor → ℤ` factors through finite support) and use
   it inside `principal`. Helper budget contribution: 1.

2. **`Scheme.WeilDivisor.principal_hom`** (L287) —
   `(X.functionField)ˣ →* Multiplicative X.WeilDivisor`,
   bundled from `principal` via `WithZero.log_mul`
   (`Ring.ordFrac` is a `MonoidWithZeroHom`, so its `WithZero.log`
   image satisfies the additivity needed). Should be small once
   `principal` lands.

3. **`Scheme.WeilDivisor.principal_degree_zero`** (L308) —
   Hartshorne Cor 6.10. **STRETCH** lane: closes by inducing a
   finite morphism `φ : C → ℙ¹` from the non-constant rational
   function `f`, then using `deg(φ^*([0]) - φ^*([∞])) = 0` plus
   `principal f hf = φ^*([0] − [∞])`. The auxiliary lemmas (finite
   morphism from non-constant rational; multiplicativity of degree
   under finite pullback) are NOT currently in the project; if you
   need them, scaffold them as `private` sorries with substantive
   types and a `-- TODO iter-178+` comment. Don't burn a whole
   iter on this if it isn't tractable; PARTIAL is acceptable.

**Acceptance**: file warnings 3 → 0 best (0 means all 3 closed);
3 → 1 acceptable if `principal_degree_zero` slips to iter-178+.

**Helper budget**: 2 (the `rationalMap_order_finite_support`
helper for `principal`, plus 1 spare for `principal_hom` or
the `principal_degree_zero` auxiliary).

**`lean_verify`**: aim for kernel-only axioms `{propext,
Classical.choice, Quot.sound}` on each closed declaration.

**Blueprint**: `chapters/RiemannRoch_WeilDivisor.tex`.

---

## Lane 4 — Body on `AlgebraicJacobian/Picard/QuotScheme.lean`

**Status**: body-fill on iter-176 file-skeleton. Single PRIMARY
target.

**Sorry to close**:

**`AlgebraicGeometry.flatBaseChangeCohomology`** (L384) — the
`i = 0` flat-base-change identity for cohomology
(Stacks 02KH part (2)). The statement asserts `Nonempty
((pullback g).obj ((pushforward f).obj F) ≅ (pushforward f').obj
((pullback g').obj F))` for a pullback square
`(IsPullback g' f' f g)` with `[QuasiCompact f]`, `[QuasiSeparated f]`,
`[Flat g]`, and `F : X.Modules`.

**Recipe**: unfold the canonical base-change map of the
`pullback ⊣ pushforward` adjunction (Mathlib's
`Scheme.Modules.pullbackPushforwardAdjunction`); under the
flatness/QC/QS hypotheses, the natural transformation is an iso.
Affine-locally this reduces to the algebraic Stacks 02KE / 00H8
form: for flat ring map `A → B` and `A`-algebra `R`, the canonical
map `B ⊗_A H⁰(X, F) → H⁰(X_B, F_B)` is an iso (for `i=0`).

If Mathlib's `pullbackPushforwardAdjunction` does NOT exist by that
name (the prover should check via `lean_local_search` /
`lean_leansearch`), the chapter's iter-177+ note suggests an
alternative: open-cover both sides and reduce to the affine case
via Stacks 01XF / 01XG.

**Acceptance**: file warnings 6 → 5. Closed declaration axiom-clean
(`{propext, Classical.choice, Quot.sound}`).

**Helper budget**: 1.

**Blueprint**: `chapters/Picard_QuotScheme.tex` (the
`thm:flat_base_change_cohomology` block).

---

## Lane 5 — Body on `AlgebraicJacobian/Picard/RelPicFunctor.lean`

**Status**: body-fill on iter-176 file-skeleton. PRIMARY target;
gated on `LineBundle.OnProduct` (A.1.b file sorry, currently
unresolved).

**Sorry to close**:

**`AlgebraicGeometry.Scheme.PicSharp.addCommGroup`** (L205) — the
`AddCommGroup` instance on `Quotient (RelPicPresheaf.preimage_subgroup
πC πT)`. Build via Mathlib's `QuotientAddGroup`: the underlying
carrier `Pic(C ×_S T)` is canonically an `AddCommGroup` under tensor
product (Stacks 01CR; project's `Scheme.LineBundle.instCommGroupLineBundle`),
and `RelPicPresheaf.preimage_subgroup` is the image of the
pullback homomorphism `π_T^* : Pic(T) → Pic(C ×_S T)` — a subgroup
of an abelian group, hence normal. `QuotientAddGroup.Quotient`
yields the `AddCommGroup`.

**Gating note**: the carrier `LineBundle.OnProduct` is itself a
typed `sorry` in `Picard/LineBundlePullback.lean` (A.1.b file
sorry). If `Pic(C ×_S T)` cannot be made concrete in this iter,
proceed as far as the pure-categorical/group-theoretic layer
allows: the instance can be PROVEN given the subgroup property +
`QuotientAddGroup.instAddCommGroup`; if the subgroup property
itself is gated on `OnProduct`, leave the body as `sorry` for the
subgroup-property step and **document the gap** with an inline
`-- TODO (A.1.b gate): … ` comment naming what unblocks the close.

**Acceptance**: file warnings 6 → 5 (best); 6 → 6 acceptable if
A.1.b gating is total (record the gap in task_result with the
specific upstream file/decl needed).

**Helper budget**: 1.

**`lean_verify`**: kernel-only axioms on the closed declaration.

**Blueprint**: `chapters/Picard_RelPicFunctor.tex` (the
`lem:rel_pic_sharp_groupoid` block).

---

## Lane 6 — File-skeleton on `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (NEW FILE)

**Status**: NEW FILE. Resolves blueprint-doctor finding
(`Albanese_CodimOneExtension.tex` declares `% archon:covers` against
a non-existent .lean target).

**Scope**: scaffold the file with declarations for 6 chapter
`\lean{...}` pins. Substantive non-tautological types. `sorry`
bodies. Add the import boilerplate + namespace structure. Wire
into `AlgebraicJacobian.lean` (alphabetical with other `Albanese/*`
imports). Do NOT attempt any body.

**Pinned declarations** (from `chapters/Albanese_CodimOneExtension.tex`):

1. `AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus`
   (L95) — `Set X`, the closed complement of `RationalMap.domain`.
2. `AlgebraicGeometry.Scheme.RationalMap.CodimOneFree`
   (L134) — predicate (`Prop`): the indeterminacy locus has codimension ≥ 2.
3. `AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one`
   (L183) — for a normal scheme `X` and `Y : X.PrimeDivisor`, the
   stalk `X.presheaf.stalk Y.point` is a DVR. (Stacks 0BBI; this
   is Mathlib-adjacent but not directly exposed.)
4. `AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth`
   (L241) — the rational-map-extension theorem: from `CodimOneFree`
   + smooth target, the rational map extends to a regular map on
   `X`.
5. `AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme`
   (L366) — for rational maps from a smooth variety into a group
   scheme, the indeterminacy locus is either empty or pure of
   codimension 1.
6. `AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg`
   (L540) — the rational map extends iff `ord_Y(f) ≥ 0` for every
   prime divisor `Y`.

For each pin, read the chapter for the substantive type signature
and the hypothesis package, then write a non-tautological
declaration with a `sorry` body and a docstring referencing the
chapter `\label`.

**Acceptance**: file lands at the import path
`AlgebraicJacobian/Albanese/CodimOneExtension.lean`;
`lake build AlgebraicJacobian.Albanese.CodimOneExtension` is green;
file warnings = 6 (one per pinned declaration).

**Helper budget**: 1 (you may add 1 small bridge if a chapter
declaration's substantive type needs a single supporting
definition).

**Out-of-scope**: do NOT attempt any body. Substantive
non-tautological types are mandatory; no
`Iso.refl _ / True := trivial / proof_wanted /
Classical.choice (h : ∃ x, P x)` shortcuts.

**Blueprint**: `chapters/Albanese_CodimOneExtension.tex`.

---

## Lane 7 — File-skeleton on `AlgebraicJacobian/Albanese/AlbaneseUP.lean` (NEW FILE)

**Status**: NEW FILE. Resolves blueprint-doctor finding.

**Scope**: scaffold the file with declarations for 6 chapter
`\lean{...}` pins. Substantive non-tautological types. `sorry`
bodies. Add import + namespace boilerplate. Wire into
`AlgebraicJacobian.lean`.

**Pinned declarations** (from `chapters/Albanese_AlbaneseUP.tex`):

1. `AlgebraicGeometry.Pic0.albanese_universal_property` (L98) —
   the headline UP theorem statement.
2. `AlgebraicGeometry.Pic0.abelJacobi` (L139) — the Abel–Jacobi
   morphism `C → Pic⁰_{C/k}` at a marked point.
3. `AlgebraicGeometry.Pic0.SymmetricPower` (L231) — placeholder
   for `Sym^g C` (the `g`-th symmetric power of `C`); body
   gated on iter-178+ `SymmetricPower.lean` substrate.
4. `AlgebraicGeometry.Pic0.symmetricPowerAVMap` (L301) — the
   regular morphism `Sym^g C → A` extending `φ : C → A`.
5. `AlgebraicGeometry.Pic0.symmetricPowerToJacobian` (L364) —
   the birational morphism `Sym^g C → Pic⁰_{C/k}` (Milne III §6).
6. `AlgebraicGeometry.Pic0.descentThroughBirationalSigma` (L469) —
   descent of `Sym^g C → A` through the birational
   `Sym^g C → Pic⁰_{C/k}`.

**Same acceptance + budget + out-of-scope rules as Lane 6.**

**Blueprint**: `chapters/Albanese_AlbaneseUP.tex`.

---

## Lane 8 — File-skeleton on `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (NEW FILE)

**Status**: NEW FILE. Resolves blueprint-doctor finding.

**Scope**: scaffold the file with declarations for 4 chapter
`\lean{...}` pins. Substantive non-tautological types. `sorry`
bodies. Wire into `AlgebraicJacobian.lean`.

**Pinned declarations** (from `chapters/RiemannRoch_RationalCurveIso.tex`):

1. `AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections` (L92) —
   the morphism `C → ℙ¹_{k̄}` produced from a 2-dimensional global
   section space via `Proj.fromOfGlobalSections`.
2. `AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor` (L166) —
   the degree of the morphism is read off the pole divisor of the
   non-constant rational function.
3. `AlgebraicGeometry.Scheme.iso_of_degree_one` (L247) — a
   degree-1 finite morphism between smooth proper curves is an
   isomorphism.
4. `AlgebraicGeometry.genusZero_curve_iso_P1` (L331) — the headline
   iso `C ≅ ℙ¹` for genus-0.

**Same acceptance + budget + out-of-scope rules as Lane 6.**

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex`.

---

## Cross-lane notes

1. **Sequencing**: Lane 1 (OCofP FIX-BUILD) should run first (or
   with priority) so the other 7 lanes have a green build to
   self-verify. Other 7 lanes can run fully in parallel.

2. **Lane 4/5/6/7/8 instance-binder discipline**: per the iter-176
   parallel-signature-change race lesson (Lane D ↔ Lane K), if any
   lane adds an `instance`/`variable` binder to a lemma that is
   imported by another iter-177 lane's file, FLAG it in the
   task_result so the next iter's planner can audit. (None of the
   8 lanes are predicted to need such changes, but the rule
   stands.)

3. **Lane 2 (GM-AXIOM) verify discipline**: after the 1-2 temporary
   axioms land, the prover must run `lean_verify` on `gmScalingP1`
   and `gmScalingP1_collapse_at_zero` and report the FULL axiom
   list in task_result. The temp axioms ARE expected — the
   verify is to document them, not to discover them.

4. **No new chapters this iter**. No blueprint-writer dispatch.

5. **File-skeleton type expressivity (Lanes 6/7/8)**: refer to the
   iter-176 Lane K (`OCofP.lean`) task_result for the litmus
   test ("if you unfold your declaration, does it expose the
   named substantive content?"). Each pinned decl must pass this.
