# Recommendations for iter-202 plan agent

## CRITICAL — must address iter-202

### CRIT-LA-1 — lean-auditor `iter201` must-fix: RelPicFunctor `-- TODO + exact sorry` excuse-comment

`AlgebraicJacobian/Picard/RelPicFunctor.lean:266-269` — the
`-- TODO (Scheme.Modules monoidal-structure gate)` comment followed
by `exact sorry` in the `addCommGroup` instance body for
`Quotient (preimage_subgroup πC πT)` is flagged **must-fix-this-iter**
by the auditor. The iter-201 plan agent characterized this as
"DEFERRAL DOCUMENTED" (gated on iter-204+ Lane RPF / TensorObjSubstrate
body fill); the auditor disagrees because the `addCommGroup`
instance is **load-bearing**: four downstream declarations (PicSharp,
PicSharp.presheaf, etc.) silently inherit a `sorryAx` taint through
it. Per descriptor rules, any excuse-comment on a load-bearing
declaration is must-fix regardless of the explanation's accuracy.

**Recommended iter-202 corrective**: either (a) advance the iter-204+
TensorObjSubstrate scaffold lane to iter-202 (3-iter pull-forward —
the user has not blocked this), OR (b) apply the iter-193 KB
carrier-soundness probe pattern to the addCommGroup instance (Prop-
valued typeclass `HasAddCommGroupOnRelPicQuotient` with a
`⟨sorry⟩` default instance), localizing the sorry into a single
instance constructor while making the addCommGroup instance body
axiom-clean. Option (b) is iter-199's Lane FGA recipe and is
1-iter; option (a) is the strategically correct path but multi-iter.

### CRIT-LA-2 — lean-auditor `iter201` major: AuslanderBuchsbaum stale "typed sorry" labels

The auditor confirmed two stale labels on declarations whose bodies
ARE now full proofs (not sorry-bodied):

- `AuslanderBuchsbaum.lean:2415` — section header
  `/-! ### Helper iter-191 Lane G (substantive typed sorry): '(x)' is not a minimal prime ...`
  is stale; `notMem_minimalPrimes_of_regularLocal_succ` (L2460-2628)
  has a full axiom-clean proof.
- `AuslanderBuchsbaum.lean:1906` — docstring for
  `finrank_cotangentSpace_quot_span_singleton_succ` says "body left
  as a single named typed sorry"; the body at L1921-2162 is closed.

The auditor also notes a related **positive finding**: the closure
of `notMem_minimalPrimes_of_regularLocal_succ` makes the chain
`isDomain_of_regularLocal` (Stacks 00NQ project-side) →
`exists_isSMulRegular_notMemSq_of_regularLocal_succ` → ... →
`CohenMacaulay.of_regular` AXIOM-CLEAN for the first time. **This
materially impacts CRIT-2 / Lane COE Stacks 00NQ analysis**: the
project may already have a project-local `IsRegularLocalRing → IsDomain`
witness (private under `isDomain_of_regularLocal`) that the Lane
COE Step A1 Matsumura helper can consume, contingent on promotion
from `private` to public. Verify with the iter-202 plan agent
BEFORE re-scoping the COE Mathlib-gap analogist.

**Recommended iter-202 corrective**: dispatch a `refactor` subagent
on `AuslanderBuchsbaum.lean` to (a) strip the stale "typed sorry"
section header at L2415, (b) rewrite the docstring at L1906 to
reflect the closed state, (c) clean up the related minor stale-label
finding at L2963 (`iter-185 typed sorry — TECHNICAL BRIDGE` over a
now-closed section), and (d) consider promoting
`isDomain_of_regularLocal` from `private` to public so Lane COE can
consume the project-local Stacks 00NQ witness.

### CRIT-0 — Lane AB-Path-B-Continue: close `_succ_pd` body

The iter-201 matrix-collapse substrate is the binding new piece per
the `ab-stacks00mf` Path B verdict. With it in hand, full closure
of `auslander_buchsbaum_formula_succ_pd` (L1696 sorry) is reachable
in ~80-120 LOC via Nat-induction restructuring:

```lean
private lemma auslander_buchsbaum_formula_succ_pd
    {R : Type u} … {M : Type u} … (k : ℕ) … (_hpd : pd R M = k + 1) :
    k + 1 + depth R M = depth R := by
  induction k generalizing M with
  | zero =>
    -- pd M = 1: K := ker (minimal f) is free (Module.Flat.of_projective
    -- + Module.free_of_flat_of_isLocalRing); pick basis ⟨φ : R^k ≃ₗ K⟩;
    -- matrix A : R^k →ₗ R^n with entries in 𝔪 = Ann κ; apply
    -- ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator;
    -- LES of Ext^*(κ, -) on 0 → K → R^n → M → 0 at i = depth R - 1
    -- yields depth M + 1 = depth R via δ-iso argument.
    sorry  -- ~50-80 LOC
  | succ k ih =>
    -- pd K = k exactly (hasProjectiveDimensionLT_ker_of_surjection +
    -- contrapositive of hasProjectiveDimensionLT_succ_…_ker);
    -- IH at K gives k + depth K = depth R;
    -- depth_of_short_exact (2): depth R - k - 1 ≤ depth M;
    -- depth_of_short_exact (3): depth M + 1 ≤ depth R - k;
    -- combine for depth M + k + 1 = depth R.
    sorry  -- ~30-50 LOC, no matrix-collapse needed
```

Dispatch as a `mathlib-build` lane with helper budget 2 on
`Albanese/AuslanderBuchsbaum.lean`. **As part of the landing, remove
`private`** per the iter-201 plan agent's option (1) commitment
(blueprint NOTE resolution).

**Substrate already in hand (iter-200 + iter-201)**:
- `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`
- `hasProjectiveDimensionLT_ker_of_surjection`
- `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`
- `depth_ker_ge_min_of_surjection_finite_localRing`
- `exists_minimalSurjection_finite_localRing` (iter-199, minimality
  clause `ker f ≤ 𝔪 • ⊤`)
- `Module.elemMap` / `elemMap_apply` /
  `linearMap_finFunR_matrix_decomp` /
  `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` (iter-201
  matrix-collapse helper)
- `ext_smul_eq_zero_of_mem_annihilator` (existing L229)
- `ideal_smul_top_pi_const` (existing L863) for the `A_{ij} ∈ 𝔪`
  membership extraction

### CRIT-1 — Lane WD-A4a Sub-build 3 dispatch

The iter-201 Sub-build 2 landed both `Ring.ordFrac_ringEquiv` (HARD
BAR, L311) and a partial PUSH-BEYOND (`Scheme.Opens.functionFieldIso`
L380 + `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` L519). The
scheme-side packaging takes `h_compat` as a parameter; iter-202
Sub-build 3 discharges it.

**Concrete claim** (verbatim from Lane WD task report):

```lean
∀ (X : Scheme.{u}) [IsIntegral X] (U : X.Opens) [Nonempty U]
    [IsIntegral U.toScheme] (Y : X.PrimeDivisor) (hYU : Y.point ∈ U)
    (r : U.toScheme.presheaf.stalk
            (Scheme.PrimeDivisor.restrictToOpen U Y hYU).point),
  (Scheme.Opens.functionFieldIso U).hom.hom
    (algebraMap _ U.toScheme.functionField r) =
  algebraMap _ X.functionField
    ((Scheme.PrimeDivisor.stalkIso U Y hYU).commRingCatIsoToRingEquiv r)
```

Both `algebraMap`s are `stalkSpecializes` to the respective generic
points (Mathlib `stalkFunctionFieldAlgebra` in
`AlgebraicGeometry.FunctionField` L81-95). The compatibility is
therefore naturality of `stalkSpecializes` w.r.t.
`Scheme.Opens.stalkIso`.

**Recipe (~30-60 LOC)**:
1. Prove morphism-level commutativity
   `stalkIso ≫ stalkSpecializes (X-gp ⤳ Y) = stalkSpecializes (U-gp ⤳ Y') ≫ functionFieldIso`
   in `CommRingCat` via `Scheme.Opens.germ_stalkIso_hom_assoc` or
   the underlying `PresheafedSpace.stalkMap.stalkSpecializes_stalkMap_assoc`.
2. Apply pointwise to discharge `h_compat`.
3. Specialize `ordFrac_stalkIso_naturality` to
   `e_K = Scheme.Opens.functionFieldIso U` (converted to `RingEquiv`
   via `.commRingCatIsoToRingEquiv`).

**First Mathlib files for the prover**:
- `Mathlib.AlgebraicGeometry.FunctionField` (L81-95).
- `Mathlib.AlgebraicGeometry.Restrict` (`Scheme.Opens.stalkIso`
  + `germ_stalkIso_hom_assoc`).
- `Mathlib.Geometry.RingedSpace.Stalks`
  (`PresheafedSpace.stalkMap.stalkSpecializes_stalkMap_assoc`).

Dispatch as a `mathlib-build` lane with helper budget 1. After
Sub-build 3, the L535 terminal closure remains blocked under USER
ROUTE C PAUSE (the prover task report's "First Mathlib files" path
strengthens the signature to `[IsNoetherian X]` and requires
Route C consumer propagation, both USER-blocked).

### CRIT-2 — Lane COE Step A1: dispatch WITH cross-file import (NOT analogist re-scout)

**The iter-201 lean-auditor cross-file finding flips the original
CRIT-2 recommendation.** The Lane COE iter-201 prover scout
correctly identified that Mathlib b80f227 lacks
`IsRegularLocalRing → IsDomain` (Stacks 00NQ) — but the auditor
located a **private project-local witness already in the AB file**:

- `AuslanderBuchsbaum.lean:2657` `isDomain_of_regularLocal` —
  strong-induction-on-spanFinrank proof, axiom-clean. Closure chain
  consumes `regularLocal_quotient_isRegularLocal_of_notMemSq` +
  `notMem_minimalPrimes_of_regularLocal_succ` (closed prior; see
  CRIT-LA-2 stale-label flag). `CohenMacaulay.of_regular` is
  axiom-clean for the first time.
- `AuslanderBuchsbaum.lean:~2200`
  `regularLocal_quotient_isRegularLocal_of_notMemSq` — provides the
  `A/(f₁) → IsRegularLocalRing` preservation (Mathlib gap #2 above).

**Two of three "Mathlib gaps" are project-local witnesses with
promotion-only cost** (private → public OR cross-file `import`).
Only `IsRegularLocalRing.localization` (Stacks 00OF) remains
genuinely absent at both Mathlib AND project level.

**Recommended iter-202 dispatch**: a `mathlib-build` prover lane on
`Albanese/CodimOneExtension.lean` Step A1 with explicit cross-file
directive:
1. Promote `isDomain_of_regularLocal` and
   `regularLocal_quotient_isRegularLocal_of_notMemSq` from `private`
   to public in `AuslanderBuchsbaum.lean` (refactor scope, ~2 LOC).
2. Import the AB module into the COE file (if not already).
3. Use the project-local witnesses to discharge the Matsumura
   helper's RLR-IsDomain dependency.
4. The conormal-localisation iso for `IsLocalization.AtPrime`
   (Stacks 02JK at non-Away primes) remains a residual gap — the
   iter-202 dispatch should attempt to land Step A1 modulo that
   residual.

**Cascade**: closing Step A1 also satisfies the Lane T32
re-engagement trigger (named "`COE Stage 6.B Krull-dim formula
(Stacks 00OE) closed`" but materially gated on
`IsRegularLocalRing → IsDomain`). iter-202 may re-engage Lane T32
as Lane COE derivative in the same iter.

**Do NOT** dispatch a `mathlib-analogist` re-scout before
attempting the cross-file dispatch — the analogist would search
Mathlib (where the iter-201 scout already confirmed absence) and
would not surface the AB-file project-local witnesses.

## HIGH — chapter expansions needed (plan-agent edits)

### MED-3a — WD chapter: pin `functionFieldIso` (per `lean-vs-blueprint-checker wd-iter201`)

The wd-iter201 checker verified all 21 existing blueprint pins
resolve and are signature-faithful; all 5 new `\leanok` markers
land on the correct blocks. The single **major** finding:

- `AlgebraicGeometry.Scheme.Opens.functionFieldIso` (public
  `noncomputable def` added iter-201 at L380) is missing a
  `\lean{...}` pin in the blueprint. The "End-to-end map" paragraph
  references it informally three times as the Sub-build 2/3
  bridge (`e_K = Scheme.Opens.functionFieldIso U`) but never wraps
  it in a `\begin{definition}` block. Sub-build 3 (iter-202) will
  consume it as the primary entry point.

Two secondary findings:
- **Soon**: `\lean{AlgebraicGeometry.rationalMap_order_finite_support}`
  pins a `private` declaration; `sync_leanok` may not resolve the
  qualified name cleanly. Pre-existing, acknowledged in the blueprint.
- **Minor**: section comment at `WeilDivisor.lean:1225` says
  "typed-sorry instance scaffolding" but `isRegularInCodimOneProjectiveLineBar`
  (L1264-1481) is now a complete axiom-clean proof — stale label.

**Recommended iter-202 plan-agent edits**: dispatch a
`blueprint-writer` for `RiemannRoch_WeilDivisor.tex` to (a) add a
`\begin{definition}…\lean{AlgebraicGeometry.Scheme.Opens.functionFieldIso}`
block in the "Open-immersion descent" section; (b) flag the
`rationalMap_order_finite_support` private/pin issue as part of
the same chapter touch.

### MED-3 — WD chapter: pin iter-201 Sub-build 2 substrate

Per the Lane WD task report, the chapter `RiemannRoch_WeilDivisor.tex`
should add `\lean{...}` pins for the 3 new public substrate decls:

- `Ring.ordFrac_ringEquiv` (Sub-build 2 anchor)
- `Scheme.Opens.functionFieldIso` (Sub-build 2 PUSH-BEYOND anchor)
- `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` (Sub-build 3
  entry point)

The chapter already has the "End-to-end map: Sub-builds 1--3"
paragraph at L388-433; this would convert prose into explicit pins
that `sync_leanok` can verify. The 3 ord-naturality helpers
(`Ring.ord_ringEquiv`, `Ring.nonZeroDivisors_ringEquiv`,
`Ring.ordMonoidWithZeroHom_ringEquiv`) are ancillary and need not
be pinned individually.

### MED-3b — AB chapter: pin + private/public + Path B narrative tense (per `lean-vs-blueprint-checker ab-iter201`)

The ab-iter201 checker confirms 14 `\lean{...}` pins all resolve,
and the 4 iter-201 matrix-collapse private helpers align with the
chapter's Path B recipe prose (no pins expected for private decls).
The checker's findings:

- **Major**: `auslander_buchsbaum_formula_succ_pd` is `private` with
  an active `\lean{...}` pin — `sync_leanok` cannot resolve the
  qualified name on a private declaration. The iter-201 plan
  committed option (1) (remove `private` at closure landing) but
  the closure has not landed; the pin remains effectively stale
  until iter-202 closes the body AND removes `private`. Tie this
  to CRIT-0 in the iter-202 prover directive.
- **Soon**: the chapter's Path B paragraph still uses future-recipe
  tense (e.g. "the matrix-collapse helper *will be*") — iter-201
  landed the substrate, so the prose should switch to past tense
  + cite the 4 landed helpers by name.
- **Minor**: stale line reference (L1290 vs actual L1418+); missing
  pin for public `exists_isRegular_of_regularLocal` (L3006);
  blueprint API-path prose differs slightly from the implemented
  path (same mathematical content); stale "typed sorry" comment in
  a private helper (companion to lean-auditor's CRIT-LA-2).

Recommended iter-202 plan-agent edits to the AB chapter:
(a) update the Path B paragraph to past tense + name the 4
landed helpers, (b) add `\lean{...}` pin for
`exists_isRegular_of_regularLocal`, (c) refresh stale line numbers
once the iter-202 closure lands.

### MED-4 — AB chapter: Path B matrix-collapse substrate prose

Per the Lane AB task report, the chapter
`Albanese_AuslanderBuchsbaum.tex` `\subsec:succ_pd_gap_sequence`
already mentions the matrix-collapse helper in prose (L931). Update
the gap-table cell for gap (2) to reflect:

- **matrix-collapse substrate CLOSED iter-201** (the analogist Path
  B's binding new helper);
- the residual binding is the LES bookkeeping + Nat-induction
  assembly, no longer a Mathlib substrate gap;
- the iter-202 closure plan: `induction k generalizing M`, base
  case via matrix-collapse + LES, inductive step via
  `depth_of_short_exact` (2)+(3) — no matrix-collapse needed for
  k≥1.

No `\lean{...}` pins to add (the 4 matrix-collapse helpers are
`private`).

### MED-5 — COE chapter: Mathlib gap acknowledgment

Per the Lane COE task report, the chapter
`Albanese_CodimOneExtension.tex` Jacobian-witness recipe should
explicitly acknowledge the three Mathlib gaps:

- `IsRegularLocalRing → IsDomain` (Stacks 00NQ);
- `A / (f₁) → IsRegularLocalRing` preservation;
- `IsRegularLocalRing.localization` (Stacks 00OF) — confirmed
  ALSO absent (closes off the alternative routing).

This converts the iter-201 plan's "Mathlib upstream PR candidate"
language into a concrete enumeration with verified-absent statuses.
The chapter's iter-201 plan-agent narrative still frames Step A1 as
30-50 LOC; this should be honestly revised to 100-200 LOC + the
prerequisite gaps.

## MEDIUM — strategic items

### MED-5b — COE chapter: Mathlib API state corrections + iter-201 substrate prose (per `lean-vs-blueprint-checker coe-iter201`)

The coe-iter201 checker confirms 12/12 declarations resolve and
the 3 sorries are correctly tracked. 4 findings:

- **Soon**: blueprint API-state paragraph INCORRECTLY claims
  `IsRegularLocalRing.localization_isRegularLocalRing` (Stacks 00OF)
  EXISTS in Mathlib b80f227 — the iter-201 prover grep + auditor
  cross-check confirmed it is ABSENT. The blueprint claim misleads
  the iter-202+ planner about a viable route.
- **Soon**: Step A1 recipe omits `IsRegularLocalRing → IsDomain`
  (Stacks 00NQ) and `A/(f₁) → IsRegularLocalRing` preservation
  from its Mathlib-gap enumeration; the recipe's ~30-50 LOC
  estimate is wrong by 5-10× when read against Mathlib alone.
  **Note (post-auditor)**: this finding's premise is partially
  superseded by the lean-auditor `iter201` cross-file discovery
  (the project HAS private project-local witnesses for both pieces
  in `AuslanderBuchsbaum.lean`). The blueprint update should say:
  "Mathlib lacks 00NQ and A/(f₁)-preservation; the project supplies
  both privately in AuslanderBuchsbaum.lean. iter-202 promotes
  these to public and imports cross-file" — converting the LOC
  estimate to ~10-30 LOC (cross-file consumption).
- **Soon**: the 3 new iter-201 private substrate theorems
  (`submersivePresentation_relation_cotangent_mk_linearIndependent`,
  `…_localized`,
  `ringKrullDim_quotient_localization_MvPolynomial_of_regular`)
  are absent from the blueprint narrative. The chapter does not
  distinguish A2 sub-pieces that are axiom-clean (the first two)
  from those still open (the conormal-localisation iso for
  `IsLocalization.AtPrime` — the residual A2 gap).
- **Minor**: stale Lean docstring name at L659 (iter-200 carry-over).

**Recommended iter-202 plan-agent edits**: dispatch a
`blueprint-writer` for `Albanese_CodimOneExtension.tex` to update
(a) Stage 6.B API-state paragraph (Stacks 00OF MISSING; project-
local 00NQ + A/(f₁)-preservation witnesses EXIST), (b)
`\subsec:stage6_iib_substrate_iter200` to add an iter-201 sub-block
naming the 3 new substrate theorems with their A2 sub-role
classification, (c) revise Step A1's LOC estimate downward
(~10-30 LOC for cross-file consumption from AB).

### MED-6 — STRATEGY.md velocity refresh

iter-201 lands at 78 sorries (net 0). The realistic projection band
was 78 → ~76-77 (−1 to −2); actual outcome is worst-case 78 → 78.
Update:

- A.4.a row: Sub-build 2 CLOSED iter-201 (HARD BAR + partial
  PUSH-BEYOND); Sub-build 3 = iter-202 target; revised iters-left
  +1 if iter-202 lands Sub-build 3 with terminal-closure deferred
  to USER unblock.
- A.4.b row: matrix-collapse substrate CLOSED iter-201; binding
  residual = LES bookkeeping + Nat-induction. Estimate 1-2 iters.
- A.4.c.0 row: 3 substrate sub-pieces landed (A2 cotangent
  forward-ergonomics + transport + Step 1+2+3 composite);
  substantive A1 closure gated on 3 Mathlib gaps; iters-left
  honestly revised to "blocked, awaiting analogist re-scout +
  potential 100-200 LOC project build" instead of the current
  "~3-6 (revised iter-201)".

### MED-7 — progress-critic stuck-protocol carry

iter-201 progress-critic `route201` returned STUCK on all 3 lanes
with severity AB > WD > COE. The iter-201 plan agent applied
correctives (blueprint expansion + STRATEGY.md estimate refresh +
TO_USER escalation note for AB ℕ∞ arithmetic). The iter-201
outcome:

- **WD**: STUCK corrective fired correctly — the iter-201 plan
  agent's "End-to-end map" paragraph + STRATEGY.md velocity
  revision both held; iter-201 outcome is consistent with the
  Sub-build cascade trajectory. **Resolved**.
- **AB**: STUCK corrective fired correctly — `ab-stacks00mf`
  analogist Path B verdict obviated the User-escalation
  requirement; iter-201 landed the binding new substrate.
  **Resolved**.
- **COE**: STUCK corrective fired the "API choice" paragraph
  resolution but the iter-201 prover scouted three Mathlib gaps
  that the corrective did not name. The corrective NEEDS iter-202
  follow-up: re-dispatch progress-critic `route202` after the
  CRIT-2 analogist verdict to re-assess COE convergence.

## LOW — informational

### LOW-1 — `sync_leanok` 5-marker WeilDivisor sync

The deterministic `sync_leanok` ran iter=201 with 5 added / 0
removed touching `RiemannRoch_WeilDivisor.tex`. The 5 markers
correspond to the iter-200 Sub-build 1 (`restrictToOpen`, `ofOpen`,
`equivOpen`, `stalkIso`, `IsRegularInCodimensionOne.instOpen`)
chapter blocks now being source-pinned to their iter-201 pin form
(the iter-201 plan agent landed those pins in the new
§"Open-immersion descent for prime divisors"). No manual
intervention required.

### LOW-2 — TO_USER FYI carry-over

Both iter-200 lean-auditor must-fix items (RPF `-- TODO + exact
sorry`; AlbaneseUP `bundle := sorry` excuse-comment) remain HELD
per the iter-201 plan's Held-lanes rationale (gated on
TensorObjSubstrate scaffold + Route C re-engagement respectively).
The deferral framings track strategy state honestly, not delaying
tactics. No iter-202 corrective needed.

### LOW-3 — Knowledge Base additions

The iter-201 outcome surfaces 2 new reusable proof patterns and 1
new known-blocker entry for `PROJECT_STATUS.md`'s Knowledge Base
(see the iter-201 review sidecar). These are tracked in the next
plan agent's reading queue.
