# Iter-178 prover objectives — per-lane directives

7 lanes. Each maps to exactly one `.lean` file. Dispatch in parallel.

## Process change — parallel-signature-race mitigation

Per progress-critic `route178` dispatch-level finding (2 consecutive
iters of build broken by parallel signature-change race; iter-176 Lane K
↔ Lane D; iter-177 Lane FIX-BUILD threading vs Lane WD's new typeclass).

**For iter-178 onward, the plan agent flags signature-mutating lanes
at composition time.** A signature-mutating lane is one that:
- Adds / modifies / removes a typeclass parameter on an existing
  declaration's signature.
- Adds / modifies a `variable` block typeclass binder in a namespace.
- Adds / removes / reorders an explicit hypothesis on an exported
  declaration.

When a lane is signature-mutating, the planner enumerates the
**downstream consumer files** of the modified signature in the
objectives file. The lane's prover directive includes:
> "This lane modifies `<exact decl>`'s signature. Downstream consumers
> in files `<list>` will need the same threading. Either (a) thread
> into all listed consumers in the SAME prover lane, OR (b) record in
> the task result a heads-up so iter-178+ planner schedules a follow-up
> FIX-BUILD lane."

### Signature-mutating lane audit (this iter)

Audit of the 7 lanes below:
- **Lane 1 FIX-BUILD #2** — threads new instance binder into OCofP.lean.
  Not signature-mutating on EXPORTED decls (variable-block addition
  only); BUT the variable-block addition propagates to every existing
  decl in the namespace. Downstream consumer audit: there are NO
  inter-file consumers of `lineBundleAtClosedPoint` namespace
  declarations (the namespace's lemmas are internally consumed by
  OCofP's own `globalSections_iff` + `exists_nonconstant_genusZero`,
  themselves consumed only by `RationalCurveIso.lean` Pin 4 cross-ref
  in AVR.lean — not exporting `lineBundleAtClosedPoint`-namespace
  declarations). Safe.
- **Lane 2 AVR-IOTAGM** — body-fill on existing signature; no
  signature mutation. Safe.
- **Lane 3 WD-DEGREE** — body-fill on existing signature
  (`principal_degree_zero` body); no signature mutation. Safe.
- **Lane 4 CodimOne-BODIES** — 2 body-fills on existing signatures;
  no signature mutation. Safe.
- **Lane 5 RatCurveIso-FIX+BODY** — **SIGNATURE-MUTATING**: changes
  `_hφ_ff : Nonempty (C'.left.functionField ≅ C.left.functionField)`
  to `_hφ_ff : Nonempty (C'.left.functionField ≃+* C.left.functionField)`.
  Affects: `iso_of_degree_one` signature change. Downstream consumers:
  exhaustive grep `iso_of_degree_one` in tree:
  - `AbelianVarietyRigidity.lean` L290 `genusZero_curve_iso_P1` is a
    `sorry`-bodied theorem that the chapter says chains
    `iso_of_degree_one` as the final step. The current `sorry`
    body does NOT reference `iso_of_degree_one` directly (it's a
    bare sorry).
  - No other file consumes `iso_of_degree_one` (it's new in iter-177).

  **Lane 5 prover directive includes the heads-up.** Since no current
  consumer chain breaks, the signature change is safe THIS iter — but
  any iter-179+ planner targeting `genusZero_curve_iso_P1` body must
  use the new `≃+*` signature.
- **Lane 6 QS-IsIso** — body-fill on the existing named helper
  `canonicalBaseChangeMap_isIso` signature; no signature mutation.
  Safe.
- **Lane 7 AB-PROJDIM** — body-fill on `projectiveDimension := sorry`
  to a concrete one-liner; no signature mutation. Safe.

**Verdict**: Lane 5 is the only signature-mutating lane, with no
current consumer impact. No parallel-race risk this iter.

---

## Lane 1 — FIX-BUILD #2 on `AlgebraicJacobian/RiemannRoch/OCofP.lean`

**Status**: PRIMARY MUST-FIX. Run with priority (high concurrency
position).

**Problem**: iter-177 Lane WD introduced a new typeclass
`Scheme.IsRegularInCodimensionOne` and added it to
`Scheme.WeilDivisor.principal`'s signature (in
`RiemannRoch/WeilDivisor.lean`). `OCofP.lean:335` calls
`Scheme.WeilDivisor.principal (X := C.left) f hf` inside the
`exists_nonconstant_genusZero` theorem body but does not declare
`[Scheme.IsRegularInCodimensionOne C.left]`. `lake build`
fails with `failed to synthesize instance C.left.IsRegularInCodimensionOne`.

**Required fix**: thread `[Scheme.IsRegularInCodimensionOne C.left]`
into the namespace variable block for `lineBundleAtClosedPoint`
(around L156 — where the iter-177 Lane FIX-BUILD already added
`[IsLocallyNoetherian C.left]`). This propagates to
`exists_nonconstant_genusZero` (and to the other 4 namespace decls,
each of which currently has a `sorry` body and will need the instance
when they're filled).

**Acceptance**: `lake build AlgebraicJacobian` returns 0 errors;
file warnings exactly 5 (the 5 existing sorries).

**Helper budget**: 0. This is a pure 1 LOC threading.

**Out-of-scope**: do NOT attempt the body of any of the 5 sorries
in this file. Body lanes for OCofP are iter-179+ work, smallest first
(`dim_eq_two_of_genusZero` once RR.2 lands per iter-176 review
ordering).

**Blueprint**: `chapters/RiemannRoch_OCofP.tex`.

---

## Lane 2 — AVR-IOTAGM on `AlgebraicJacobian/AbelianVarietyRigidity.lean`

**Status**: First body-fill on the genus-0 arm post-HARD-STOP. The
iter-177 plan-agent flagged this as "iter-178 follow-up #1": with
`gmScalingP1` now axiom-clean over the 2 TEMP axioms, this lane is
closeable axiom-clean OVER THE TEMP AXIOMS (no NEW project axioms).

**Target**: fill the sorry at `AbelianVarietyRigidity.lean:86` body
of `iotaGm_isDominant`. The chapter has this as Milne III.6.1
preliminary; the statement is "the inclusion `ι_𝔾_m : 𝔾_m → ℙ¹` is
dominant", which Mathlib should support via `IsOpenImmersion ⟹
IsDominant` (or by `IsDominant.of_isOpenImmersion` if shipped).

**Recipe** (suggested; prover discretion):

```lean
-- L86 currently is `:= sorry`. Replace with:
theorem iotaGm_isDominant (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    IsDominant (iotaGm kbar).left := by
  -- iotaGm is the open immersion `𝔾_m → ℙ¹` = `Proj.awayι` away from a coord.
  -- Mathlib should ship `IsOpenImmersion.isDominant` or
  -- `IsOpenImmersion ⟹ IsDominant` for irreducible target.
  exact IsOpenImmersion.isDominant _  -- or similar
```

The full chain has gmScalingP1 reused; if the Mathlib lemma is named
differently, use `lean_leansearch` for "IsOpenImmersion IsDominant"
or `lean_loogle` for `IsOpenImmersion ?f → IsDominant ?f`.

**Acceptance**: `iotaGm_isDominant` body closes; file sorry count
2 → 1; `lean_verify AlgebraicGeometry.iotaGm_isDominant` reports
axioms `{propext, Classical.choice, Quot.sound,
gmScalingP1_chart_data_temp, gmScalingP1_collapse_at_zero_temp}` —
i.e. axiom-clean OVER the temp axioms, NO new project axioms.

**Helper budget**: 0. This should be a one-liner via the right
Mathlib lemma.

**Out-of-scope**: do NOT touch the other AVR sorry
`genusZero_curve_iso_P1` (L290 — gated on full RR.4 chain). Do NOT
touch the TEMP axioms.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated;
covers AVR + G0BO sub-files + RigidityLemma).

---

## Lane 3 — WD-DEGREE on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

**Status**: 2nd-attempt STRETCH (per progress-critic `route178`:
"STRETCH-then-deferred-then-retry is not a churn pattern when the
file has independent momentum"). iter-177 closed `principal` +
`principal_hom` axiom-clean; only `principal_degree_zero` (L407)
remains body-pending.

**Target**: fill the sorry at L407 body of `principal_degree_zero`.

**Recipe** (Hartshorne II.6.10):

Case-split `f ∈ image (algebraMap k̄ K(C))` vs not.

- **Constant case** (`f = (algebraMap k̄ K(C)) c` with `c ≠ 0`):
  `f` is a unit in every stalk ⟹ `Ring.ordFrac _ f = 1` ⟹ all
  components of `principal f hf` are 0 ⟹ degree is 0.
  - Need lemma: "Ring.ord (or .ordFrac) of a unit is 1" — searchable
    via `lean_leansearch "Ring.ord unit one"` (iter-177 search did not
    find this directly; try `lean_loogle "Ring.ordFrac ?u (IsUnit ?u)"`).
  - If the lemma is absent, prove it inline: unit in `α` ⟹
    `Multiplicative.ofAdd 0` value of `Ring.ord`; ≈10-20 LOC.

- **Non-constant case**: factor `φ : C → ℙ¹` finite (since
  non-constant on a smooth proper curve) + pullback degree
  multiplicativity (Hartshorne II.6.9: `deg(φ^*[D]) = deg(φ) · deg(D)`).
  Then `principal f hf = φ^*[0]_{ℙ¹}` (the divisor of `f` viewed as
  rational on `ℙ¹`), and `[0]_{ℙ¹}` has degree 0, so by
  multiplicativity `deg(principal f hf) = 0`.
  - This case requires the construction `φ : C → ℙ¹` from `f`
    (which is what Lane 5 below is trying to land via Pin 1).
  - Substantial substrate. May STRETCH (PARTIAL acceptable).

**Acceptance**: best case `principal_degree_zero` body closes (2 → 1
file sorries); stretch — PARTIAL with the constant case closed +
non-constant case as helper sorry (still 2 sorries, one factored).

**Helper budget**: 2 (one for `Ring.ord_eq_one_of_isUnit` lemma; one
for the finite-pullback degree multiplicativity helper).

**Out-of-scope**: `rationalMap_order_finite_support` helper sorry
(L205) — Hartshorne 6.1 finite-support; Mathlib gap; defer.

**Blueprint**: `chapters/RiemannRoch_WeilDivisor.tex`.

---

## Lane 4 — CodimOne-BODIES on `AlgebraicJacobian/Albanese/CodimOneExtension.lean`

**Status**: First body-fill on the iter-177-NEW file. 2 ready sorries
of the 4: `localRing_dvr_of_codim_one` (smallest) and
`extend_iff_order_nonneg` (small).

**Targets**:

### `Scheme.localRing_dvr_of_codim_one` (L195 — primary)

```
theorem localRing_dvr_of_codim_one
    (X : Over (Spec (.of kbar))) [Smooth X.hom] [IsIntegral X.left]
    (z : X.left) (hz : Order.coheight z = 1) :
    IsDiscreteValuationRing (X.left.presheaf.stalk z)
```

**Recipe**: smooth ⟹ regular local stalk; regular local + Krull-dim 1
⟹ DVR (Mathlib `IsRegularLocalRing.isDiscreteValuationRing_of_dim_one`
or the equivalent in `Mathlib.RingTheory.DiscreteValuationRing.Basic`).
The bridge `coheight = 1 ⟹ KrullDim = 1` on a Noetherian integral
scheme is a Mathlib-pending gap (Stacks 02IZ / 005X); iter-178 may
need to admit it as a local lemma — but check `lean_leansearch
"Order.coheight Ring.KrullDimLE"` first.

**Acceptance**: body closes (4 → 3); axiom check kernel-only.

**Helper budget**: 1 (potential coheight ↔ KrullDim bridge).

### `Scheme.RationalMap.extend_iff_order_nonneg` (L346 — secondary)

```
theorem extend_iff_order_nonneg
    (X Y : Over (Spec (.of kbar))) [...]
    (f : X.left.RationalMap Y.left) (W : X.left.PrimeDivisor) :
    W.point ∈ f.domain ↔
    ∃ g : X.left.PartialMap Y.left, g.toRationalMap = f ∧
      W.point ∈ (g.domain : Set X.left)
```

**Recipe**: straightforward unfolding of `Scheme.RationalMap.mem_domain`
(Mathlib `Mathlib.AlgebraicGeometry.Birational.RationalMap`) + `Iff.intro`
+ reorder of conjuncts.

```lean
  unfold Scheme.RationalMap.mem_domain
  constructor
  · rintro ⟨g, hg, hxg⟩; exact ⟨g, hg.symm, hxg⟩
  · rintro ⟨g, hg, hxg⟩; exact ⟨g, hg.symm, hxg⟩
```

(or one-liner via `Scheme.RationalMap.mem_domain.symm`).

**Acceptance**: body closes (3 → 2 if Lane 4 primary lands too).

**Helper budget**: 0. Direct rewrite.

### Out-of-scope (deferred to iter-179+)

- `extend_of_codimOneFree_of_smooth` (L243) — gated on
  `cor:regular_cohen_macaulay` from `AuslanderBuchsbaum.lean`.
- `indeterminacy_pure_codim_one_into_grpScheme` (L284) — Milne's
  difference-map argument; substantial.

**Blueprint**: `chapters/Albanese_CodimOneExtension.tex`.

---

## Lane 5 — RatCurveIso-FIX+BODY on `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

**Status**: **SIGNATURE-MUTATING** + body attempt. Auditor must-fix
on `≅` (Type-iso) → `≃+*` (ring iso) + try smallest pin
(`morphismToP1OfGlobalSections`).

### Part A — Type fix (auditor must-fix, 1 LOC)

`RationalCurveIso.lean:329-330` currently:

```lean
theorem iso_of_degree_one
    ... (_hφ_ff : Nonempty (C'.left.functionField ≅ C.left.functionField))
    : Nonempty (C ≅ C') := sorry
```

Change to:

```lean
theorem iso_of_degree_one
    ... (_hφ_ff : Nonempty (C'.left.functionField ≃+* C.left.functionField))
    : Nonempty (C ≅ C') := sorry
```

`≃+*` is `RingEquiv` (preserves ring structure). The `Nonempty` wrapper
stays since the iso is data, not a Prop.

**Downstream consumer audit**: only `genusZero_curve_iso_P1` (AVR L290,
currently `sorry`) chains `iso_of_degree_one` in the RR.4 bridge. No
current consumer breaks.

### Part B — Body attempt on Pin 1 `morphismToP1OfGlobalSections` (L184)

Type:

```lean
noncomputable def morphismToP1OfGlobalSections
    (X : Over (Spec (.of kbar)))
    (f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤))
    (h : ...irrelevant-ideal-generates-top condition...) :
    X ⟶ ProjectiveLineBar kbar
```

**Recipe** (per task result): `Proj.fromOfGlobalSections` on
`projectiveLineBarGrading kbar` produces a morphism
`X.left ⟶ Proj.proj _`; lift via `Over.homMk` with a section condition
proof; chase through `Proj.fromOfGlobalSections_toSpecZero` +
`IsScalarTower kbar (𝒜 0) _`.

The analogous chain is in `Genus0BaseObjects/Points.lean:pointOfVec`
(referenced in the task result); use that as a template.

**Acceptance**: best case Pin 1 body closes (3 → 2 file sorries);
fallback — body PARTIAL or sorry remains (then sorry count unchanged
but Part A still lands).

**Helper budget**: 1 (a small `Over.homMk` section helper if needed).

**Out-of-scope**: Pin 2 `morphism_degree_via_pole_divisor` (gated on
finite-degree multiplicativity); Pin 3 `iso_of_degree_one` body
(gated on Stacks 0AVX pushforward-rank-1 argument).

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex`.

---

## Lane 6 — QS-IsIso on `AlgebraicJacobian/Picard/QuotScheme.lean`

**Status**: 2nd attempt; iter-177 landed `flatBaseChangeCohomology`
structurally via `CategoryTheory.mateEquiv`. The deep math sits in
named helper `canonicalBaseChangeMap_isIso` (L437) which has a `sorry`
body carrying Stacks 02KH (i=0 form) content. This lane attempts to
close it.

**Target**: fill body of `canonicalBaseChangeMap_isIso`.

**Recipe** (per task result iter-177):

1. Pick a quasi-compact open affine cover `{U_α}` of `X`.
2. Reduce `(pullback g)(pushforward f F)|U_α` to the algebraic case:
   for `π_α : U_α → V_α ⊆ S` affine and `V'_α = V_α ×_S S' → V_α`,
   the canonical map `O(V'_α) ⊗_{O(V_α)} H⁰(U_α, F|U_α) → H⁰(U_α ×_S S', F'|...)`
   is an iso by `Module.Flat.isBaseChange` (Stacks 00H8 / 02KE).
3. Quasi-separated `f` ⟹ `U_α ∩ U_β` is quasi-compact, so the same
   argument on double intersections gives Mayer-Vietoris.
4. Global iso follows from local-to-global on `S'.Modules`.

This is genuinely deep; the lane is acknowledged as STRETCH (likely
PARTIAL).

**Acceptance**: best case helper body closes (6 → 5 file sorries);
stretch — PARTIAL with affine-local case decomposed into named
sub-helpers (still 6 sorries but factored further).

**Helper budget**: 2 (affine-local case helper + Mayer-Vietoris gluer).

**Out-of-scope**: other 5 file-skeleton sorries (`hilbertPolynomial`,
`QuotFunctor`, `Grassmannian`, `Grassmannian.representable`,
`QuotScheme`) — all gated on Nitsure §5 (multi-iter Mathlib gap).

**Blueprint**: `chapters/Picard_QuotScheme.tex`.

---

## Lane 7 — AB-PROJDIM on `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

**Status**: lean-auditor iter-177 MEDIUM. Single one-line fix:
`projectiveDimension := sorry` is left as a typed sorry per the
"file-skeleton uniformity" excuse, despite the body being a one-line
re-export. Replace with the concrete body.

**Target**: `Module.projectiveDimension` (L168) — replace sorry with
the canonical Mathlib alias. Per the auditor's note, this is a
"one-line re-export"; check via `lean_leansearch
"Module.projectiveDimension"` or look at
`Mathlib.RingTheory.Homological.ProjectiveDimension` for the
canonical Mathlib name and re-export.

If Mathlib doesn't ship the exact alias, define inline as:

```lean
noncomputable def Module.projectiveDimension
    (R : Type u) [Ring R] (M : Type v) [AddCommGroup M] [Module R M] :
    WithBot ℕ∞ :=
  -- canonical Mathlib alias (check via leansearch); fallback:
  ...
```

Aim for a body that elaborates concretely; the type is `WithBot ℕ∞`.

**Acceptance**: body closes (6 → 5 file sorries); axiom check
kernel-only.

**Helper budget**: 0.

**Out-of-scope**: other 5 AB sorries (`depth`,
`depth_eq_smallest_ext_index`, `depth_of_short_exact`,
`auslander_buchsbaum_formula`, `CohenMacaulay.depth_eq_krullDim` field,
`CohenMacaulay.of_regular`) — all substantive multi-iter work.

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex`.

---

## Cross-lane discipline (recap)

- **Lane 1 priority**: PRIMARY MUST-FIX; restore build first.
- **No new typeclass introductions this iter** (Lane 5 is the only
  signature-mutating lane; downstream impact verified safe).
- **No 6th chart-bridge helper-retry**: HARD STOP rule from iter-176
  remains in effect; replacement plan is the mathlib-analogist
  consult #1 (cover-vs-Proj.awayι) + #2 (separated-locus alt).
- **TEMP axioms remain on the books** until iter-181 RETIRE-OR-ESCALATE
  trigger fires (per STRATEGY.md Open Q).
