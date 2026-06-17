# Iter-190 prover objectives — per-lane detail

## Lane G — `Albanese/AuslanderBuchsbaum.lean` — project-side Stacks 00NQ

**Verdict context**: progress-critic CONVERGING + escalation advisory.
3-iter recurring blocker (`isDomain_of_regularLocal` Mathlib gap)
confirmed; iter-190 plan-phase committed Option (a) per analogist
recommendation in `analogies/isregularlocalring-isdomain.md` (option 1).

**Target**: ≥1 axiom-clean intermediate helper landed toward project-
side proof of `isDomain_of_regularLocal`. Suggested candidates (pick
the cheapest first):
- `regularLocal_minimalPrimes_singleton` — for `IsRegularLocalRing R`,
  `minimalPrimes R = {⊥}` (~30-50 LOC). Reduces via Krull's height
  bound + minimal-prime-of-zero theory; uses Mathlib's `minimalPrimes`
  and `Ideal.height_le_of_minimalPrimes`.
- `regularLocal_jacobsonNilradical_eq_bot` — for `IsRegularLocalRing R`,
  `jacobsonNilradical R = ⊥` (~25-40 LOC). Uses Mathlib's
  `IsHausdorff (maximalIdeal R)` instance + `Ideal.isHausdorff_iff`.
- `regularLocal_prime_avoidance_step` — prime-avoidance helper
  specialised to regular local rings (~40-60 LOC).

**HARD BAR**: ≥1 of the above 3 helpers (or equivalent) lands axiom-
clean. Helper budget = 3.

**Recipe**: `analogies/isregularlocalring-isdomain.md` §2 enumerates
the Stacks 00NQ proof chain. Mathlib substrates confirmed present:
`ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`,
`IsHausdorff.iInf_pow`, `minimalPrimes`. The integral-domain conclusion
follows from `(R/0).IsDomain ↔ (0 : Ideal R).IsPrime`, which in turn
follows from `minimalPrimes R = {⊥}` once `⊥ ∈ minimalPrimes`.

**Out-of-scope**: closing `isDomain_of_regularLocal` itself this iter
(~300 LOC total over multi-iter). Pre-existing L835
`auslander_buchsbaum_formula` (not on critical path).

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex` (PASS).

---

## Lane I — `RiemannRoch/WeilDivisor.lean` + `RiemannRoch/RationalCurveIso.lean`

**Verdict context**: progress-critic UNCLEAR-must-act; iter-189 prover
diagnosed Pin 2 false-as-stated; iter-190 plan-phase committed Option
(a) corrective (refactor `Hom.poleDivisor` body via `positivePart`).

**Target on `WeilDivisor.lean`**:
1. New `Scheme.WeilDivisor.positivePart : X.WeilDivisor → X.WeilDivisor`
   axiom-clean via Finsupp `D ⊔ 0` lattice form (~10-15 LOC). The
   carrier `X.WeilDivisor = X.PrimeDivisor →₀ ℤ` is a Finsupp to ℤ,
   which has a `Lattice` instance via `Pi.lattice`; `D ⊔ 0` is the
   max-with-zero on coefficients.
2. Name `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
   as a NEW typed-sorry pin (~5 LOC signature) matching the blueprint
   block at `RiemannRoch_WeilDivisor.tex` §6. The body (~50-80 LOC via
   `Ideal.sum_ramification_inertia` + `Ideal.finrank_quotient_map`
   chain on affine charts) is owed iter-191+.

**Target on `RationalCurveIso.lean`**:
3. Refactor `Hom.poleDivisor` body (currently at L? — find via grep
   `noncomputable def Hom.poleDivisor`) from
   `Scheme.WeilDivisor.principal _ halg`
   to
   `(Scheme.WeilDivisor.principal _ halg).positivePart`
   (~5 LOC). This breaks the mathematical falsity that iter-189
   diagnosed.
4. Close `Hom.poleDivisor_degree_eq_finrank` body via a 1-line rewrite
   consuming `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
   (~3 LOC).
5. **(Stretch)** Pin 3 Step 2 (`iso_of_degree_one` L760 second sorry)
   via 4-step `Scheme.Hom.toNormalization` chain documented inline at
   the sorry (per `analogies/ratcurveiso-pin3.md`): (a)
   `[IsIntegralHom φ.left]` from non-constant + smooth-dim-1 ⟹ finite
   via `IsFinite.iff_isIntegralHom_and_locallyOfFiniteType`; (b)
   `[QuasiCompact φ.left]`, `[QuasiSeparated φ.left]` from `[IsProper]`;
   (c) `Scheme.Hom.normalization φ.left = C'.left` via
   smoothness/normality + `fromNormalization` iso under degree-1; (d)
   slice-category lift `C ≅ C'` from underlying `C.left ≅ C'.left`.
   ~80-150 LOC; ambitious for iter-190.

**HARD BAR**: positivePart def axiom-clean AND
`Hom.poleDivisor_degree_eq_finrank` body closes modulo named typed
sorry on `degree_positivePart_principal_eq_finrank`. Pin 3 Step 2 is
stretch (no HARD BAR; documented continuation acceptable).

**Helper budget**: 1 (the positivePart def).

**Net iter-190 Lane I projection**: 1 axiom-clean closure (Pin 2 body)
+ 1 NEW pin (`degree_positivePart_principal_eq_finrank` body iter-191+).
Net 0 on file sorry count (1 closure + 1 new typed sorry).

**Recipe** for positivePart def (Option 1 — lattice form):
```lean
noncomputable def Scheme.WeilDivisor.positivePart
    (D : X.WeilDivisor) : X.WeilDivisor := D ⊔ 0
```
If `D ⊔ 0` doesn't typecheck (Finsupp lattice instance may need
explicit imports), fall back to Option 2 (explicit Finsupp):
```lean
noncomputable def Scheme.WeilDivisor.positivePart
    (D : X.WeilDivisor) : X.WeilDivisor :=
  Finsupp.onFinset D.support (fun Y => max (D Y) 0) (by
    intro Y hY
    simp [Finsupp.mem_support_iff] at *
    by_contra h
    apply hY
    have := h
    rcases lt_trichotomy (D Y) 0 with h1 | h1 | h1
    · linarith [max_eq_left (le_of_lt h1)]
    · exact h1
    · linarith [max_eq_right (le_of_lt h1)])
```

**Blueprint**: `chapters/RiemannRoch_WeilDivisor.tex` (iter-190
plan-phase §6 added); `chapters/RiemannRoch_RationalCurveIso.tex`
(iter-190 plan-phase Pin 2 corrective NOTE added).

---

## Lane F — `Picard/QuotScheme.lean` — Step 3 axiom-clean ONLY

**Verdict context**: progress-critic CHURNING (3-iter helper-churn pattern;
net +4 sorries; HARD BAR missed 2 iters). Corrective: verify unbundle
inflection — close ONE pin axiom-clean to break the pattern.

**Target**: Close `pullback_of_openImmersion_iso_restrict` body (~30-50 LOC).

**Recipe** per iter-189 prover report:
- Chain `hU.toSpecΓ_fromSpec` (Mathlib identifies `pullback hU.fromSpec`
  with `restrict_to_U` up to natural iso) with naturality of
  `tilde.isoTop` (extracts `\top`-section of `tilde` as input module).
- Transport `Γ(Y, U)`-linear structure through the chain.
- The pin's signature uses `letI` to set up the `Γ(Y, U)`-algebra
  structure via `Scheme.ΓSpecIso` + `Module.compHom` (the iter-189
  attempt 2 design landed this structure).

**HARD BAR**: Step 3 closes axiom-clean. **NO new helpers permitted.**
Helper budget = **0**.

**Escalation**: if Step 3 fails axiom-clean iter-190, route escalates
iter-191 plan-phase to user-escalation for Mathlib upstream PR on
Stacks 01I8 + Stacks 01HH transport.

**Blueprint**: `chapters/Picard_QuotScheme.tex` (iter-190 plan-phase
2 pin blocks added).

---

## Lane B — `Genus0BaseObjects/Cross01Substrate.lean` — Substrate 2

**Verdict context**: progress-critic UNCLEAR (1 iter of data); Substrate
1 axiom-clean iter-189. Substrate 2 owed iter-190 per plan commitment.

**Target**: Close `gmRing_tensor_homogeneousAway_isDomain` body (~50-80
LOC) per `analogies/lane-b-substrate.md` §3.

**Signature** (per the analogist file):
```
theorem gmRing_tensor_homogeneousAway_isDomain
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar] {d : ℕ} (hd : 0 < d)
    {n : ℕ} (X : Fin n → kbar[Fin n]) (i : Fin n) (hi_deg : X i ∈ 𝒜 d) :
    IsDomain (gmRing kbar ⊗[kbar] HomogeneousLocalization.Away 𝒜 (X i)) := ...
```

**Recipe** (localization-polynomial iso chain): tensor of two
localizations of a polynomial ring over algebraically closed kbar.
1. `gmRing kbar = MvPolynomial Unit kbar` localised at `X 0`.
2. `HomogeneousLocalization.Away 𝒜 (X i)` = a homogeneous localization
   of a graded polynomial ring at a single homogeneous generator.
3. The tensor product over kbar of two such localizations is again a
   localization of a polynomial ring (over the joint set of generators
   minus the diagonal).
4. Polynomial ring over an algebraically closed field is a domain;
   localization preserves domain; ∴ the tensor product is a domain.

**HARD BAR**: Substrate 2 closes axiom-clean. Helper budget = 1.

**Note**: the analogist substrate recipe has not been Lean-verified at
analogist-consult stage. If signature elaborates but body stalls,
accept a 1-named-helper partial; rest closes iter-191.

**Blueprint**: `chapters/Genus0BaseObjects_Cross01Substrate.tex`
(Substrate 2 block already pinned iter-189; iter-190 prover lands
body).

---

## Lane E — `AbelianVarietyRigidity.lean` — post-refactor double close

**Verdict context**: progress-critic STUCK + OVER_BUDGET (19 iters vs
3-5 estimate; 3.8× over). iter-189 analogist verdict PROCEED-with-
refactor; iter-190 plan-phase dispatched `refactor lane-e-iotagm-packaging`
(COMPLETE).

**Post-refactor file state** (per
`task_results/refactor-lane-e-iotagm-packaging.md`):
- File now has **3 sorries** (was 2 entering iter-190): the original
  `iotaGm_r_1_range_subset` body (NEW, L150) — the iter-184 closed
  proof body did NOT transplant cleanly because of `rw`/`change` defeq
  friction between `↥(ProjectiveLineBar kbar).left` and `↥(Proj 𝒜)`;
  the pre-existing `r_1_appTop_isLocElem_eq_one` (L464 via L302-L450
  inline-doc); the pre-existing `genusZero_curve_iso_P1` (L788; RR
  bridge, untouched).
- The refactor lands `iotaGm_r_1` def + `iotaGm_r_1_fac` axiom-clean,
  unblocking the iter-190 prover's use of `IsOpenImmersion.lift_app`.

**Target — 2 closures this iter**:

1. **`iotaGm_r_1_range_subset` body** (new L150 sorry; recipe (b) per
   refactor report): point-witness construction. Build a witness
   `y : Spec (Away 𝒜 (X 1))` such that `awayι y = onePt.left x` by
   composing `Spec.map (homogeneousLocalizationAwayIso kbar 1).symm`
   with the chart-1 evaluation map; the `Proj.basicOpen` membership
   is then a one-shot calc. ~30-50 LOC. The original iter-184 closed
   body is preserved as a block comment in the file for adapting;
   route (a) (marking `ProjectiveLineBar` `@[reducible]`) is out of
   scope for this lane (it's a Lane-A change).

2. **`r_1_appTop_isLocElem_eq_one` helper** (closes L464 sorry).
   ~60-80 LOC per `analogies/lane-e-projappiso.md` Section 3. With
   `iotaGm_r_1` now exposed as a `def` (post-refactor), this consumes:

   - Step 1: `unfold iotaGm_r_1` ⟹ `r_1 := IsOpenImmersion.lift _ _ _`.
   - Step 2: `rw [IsOpenImmersion.lift_app]` at `V = ⊤` ⟹ `appIso.inv ≫ onePt.left.app (basicOpen 𝒜 (X 1)) ≫ presheaf.map`.
   - Step 3: `Proj.opensRange_awayι` ⟹ `awayι ''ᵁ ⊤ = basicOpen 𝒜 (X 1)`.
   - Step 4: `awayι = basicOpenIsoSpec.inv ≫ basicOpen.ι` ⟹ chain
     through `basicOpenToSpec_app_top` + `basicOpenIsoAway.hom = awayToSection`.
   - Step 5: `fromOfGlobalSections_morphismRestrict` (or `_resLE`) on
     `onePt.left` restricted to `basicOpen 𝒜 (X 1)` ⟹
     `toBasicOpenOfGlobalSections`-shape morphism.
   - Step 6: Evaluate on `isLocElem = X_0 / X_1`: `IsLocalization.map _ (evalIntoGlobal v) sends [X_0 / X_1] ↦ (evalIntoGlobal v X_0) / (evalIntoGlobal v X_1) = 1 / 1 = 1`.

**HARD BAR**: ≥1 of (1)/(2) closes axiom-clean. Ideal: BOTH close
(net Lane E sorry count 3 → 1). Helper budget = 1.

**Escalation**: if route (b) point-witness fails for (1), prover may
fall back to inlining the body from the comment + adapting; if
`r_1_appTop_isLocElem_eq_one` body fails, the L464 sorry remains and
the prover documents specifically WHICH Mathlib gap blocks closure
(Step 4 chain is the likely friction point — `Proj.awayι_appIso_top`
is the unowned Mathlib simp lemma).

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (CONDITIONAL PASS;
Mathlib gaps documented).

---

## Plan-phase deferrals (no iter-190 prover dispatch on these)

### `Picard/IdentityComponent.lean` — Lane A.3.i HALTED

Progress-critic CHURNING + HARD SCOPE CAP escalation triggered iter-189.
mathlib-analogist `lane-a3i-isconnected-prod` directive prepared at
`.archon/logs/iter-190/mathlib-analogist-lane-a3i-isconnected-prod-directive.md`
but dispatch DEFERRED to iter-191 plan-phase (max_parallel=1 budget;
non-blocking since A.3.i not dispatched iter-190).

### `Albanese/CodimOneExtension.lean` — Lane M↓ RE-OPENED, iter-191+

Strategy-critic REJECT on Option (c) accepted; Lane M↓ committed
project-side Option (a) build (~8-15 iters / ~150-300 LOC; Stacks 00TT
proof chain: smooth → flat → polynomial presentation → regular sequence
→ regular local ring). iter-191 plan-phase: dispatch first prover to
scaffold the substrate skeleton.

### `RiemannRoch/RRFormula.lean` — Lane H HALTED

H¹ chapter LANDED iter-190 plan-phase; iter-191+ scaffolds
`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` per the new chapter,
then closes `H1_skyscraperSheaf_finrank_eq_zero` body.

### `RiemannRoch/OCofP.lean` — downstream 3 sorries dropped iter-190

3 remaining sorries gated on RR.2.H¹ scaffolding iter-191+; dispatching
iter-190 would risk wasted PARTIAL.

### `Genus0BaseObjects/GmScaling.lean` — Lane B consumers HALTED

Pending Substrate 2 close in `Cross01Substrate.lean`; iter-191+
consumes substrates for 3 sorry closures together.

### `RiemannRoch/OcOfD.lean` — Lane J STRUCTURALLY BLOCKED

DO NOT DISPATCH (iter-187 finding).
