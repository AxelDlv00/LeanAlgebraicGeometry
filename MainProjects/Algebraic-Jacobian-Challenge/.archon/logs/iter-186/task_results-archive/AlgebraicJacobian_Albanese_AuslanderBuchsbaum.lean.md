# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Iter-185 Lane G — STRUCTURAL PARTIAL on `exists_isRegular_of_regularLocal`

**Status entering**: 2 sorries (`auslander_buchsbaum_formula` L835 +
`regularLocal_inductive_step` L988, bare).

**Status exiting**: 3 sorries (`auslander_buchsbaum_formula` L835 unchanged
+ new `exists_isSMulRegular_quotient_isRegularLocal_succ` L975 typed Mathlib
gap + `regularLocal_inductive_step` L1008 inline technical bridge sorry).

**Net**: 2 → 3 (+1 sorry). Within PARTIAL allowance (`2 → ≤3`, helper budget
2/2, per iter-185 objectives Lane G directive).

**Lake build**: GREEN. **Axioms** on `exists_isRegular_of_regularLocal`:
`propext, sorryAx, Classical.choice, Quot.sound` (standard Lean axioms plus
the typed-sorry residual; **NO project axioms introduced**, 6th consecutive
zero-axiom build retained).

---

## `exists_isSMulRegular_quotient_isRegularLocal_succ` (NEW HELPER, L965)

### Attempt 1 (iter-185)
- **Approach**: Per iter-185 Lane G directive (PIVOT to
  `exists_isRegular_of_regularLocal` per iter-184 task_result + checker
  `iter184-auslander` analysis), spent ~15 min searching Mathlib for direct
  shipment:
  - `lean_local_search IsRegularLocalRing.` → empty (only the class def).
  - `lean_leansearch "regular local ring is integral domain"` → no match for
    Stacks 00NQ.
  - `lean_leansearch "IsRegularLocalRing IsDomain"` → no match.
  - `lean_leansearch "system of parameters regular sequence regular local ring"`
    → only `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` (the upper
    bound, already used iter-181 in Helper 1 above).
  - `lean_leansearch "Koszul complex regular sequence acyclic"` → only
    `IsSMulRegular.smulShortComplex_shortExact` (NOT Koszul-complex
    infrastructure).
  - `grep -ri '*Koszul*'` Mathlib → no Koszul-complex files at b80f227.
  - Read `Mathlib.RingTheory.RegularLocalRing.Defs` — only the class +
    `iff_finrank_cotangentSpace` + the PID-is-regular instance; no
    `IsRegularLocalRing → IsRegular (parameters)` API shipped.
- **Verdict**: NEITHER (a) direct `IsRegularLocalRing.exists_isRegular`
  shipment NOR (b) Koszul-complex acyclicity infrastructure are present in
  Mathlib `b80f227`. Both paths (a) and (b) of the iter-185 directive are
  blocked by Mathlib substrate gaps.
- **Result**: PARTIAL — landed a structural scaffold per directive item 3
  ("scaffold path (b) Koszul-homology proof using `depth_eq_smallest_ext_index`
  as bridge, even partial typed-sorry helpers count toward acceptable") via
  a different scaffolding choice: extracted ONE narrow typed-sorry helper
  for the consolidated Stacks 00NQ + 00NU substrate. See "Outcome" below.

### Outcome
- New helper `exists_isSMulRegular_quotient_isRegularLocal_succ` (L965, typed
  `sorry` at L975) consolidates BOTH Mathlib substrate gaps into one focused
  signature:
  ```lean
  private lemma exists_isSMulRegular_quotient_isRegularLocal_succ
      {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
      [IsRegularLocalRing R] {k : ℕ}
      (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1) :
      ∃ (x : R), x ∈ IsLocalRing.maximalIdeal R ∧ IsSMulRegular R x ∧
        ∃ _ : IsRegularLocalRing (R ⧸ Ideal.span {x}),
          (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x})).spanFinrank = k
  ```
- Future iter can attack Stacks 00NQ + 00NU directly via this signature
  (~300 + ~200 LOC of project work, OR Mathlib-upstream contributions).
- The signature is the precise statement needed: x extraction with both
  NZD property AND quotient regularity preservation. Future Stacks 00NQ
  closure ⟹ minimal generator extraction + use of Mathlib's
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` for the
  spanFinrank manipulation.

---

## `regularLocal_inductive_step` body (L998)

### Attempt 1 (iter-185)
- **Approach**: Rewrote the previously-bare-sorry body as an axiom-clean
  structural scaffold consuming the new Helper 1 plus the IH:
  1. Extract `x, hxMem, hxReg, hRLR, hdim_quot` from Helper 1.
  2. Apply IH on `R ⧸ Ideal.span {x}` (uses the embedded
     `IsRegularLocalRing` instance from Helper 1) to obtain `rs'_q :
     List (R ⧸ (x))` of length `k`.
  3. Lift `rs'_q` to `rs' : List R` via `Function.surjInv` of
     `Ideal.Quotient.mk_surjective` (axiom-clean).
  4. **Length proof** (`rs'.length = k`): `simp [rs', hlen_q]` — axiom-clean.
  5. **`rs'.map mkq = rs'_q` section identity** (`hmkmap`): explicit via
     `List.map_map + List.map_congr_left + hg` (the `Function.surjInv_eq`
     property). Axiom-clean.
  6. **Membership in `𝔪 R`** (`hmem_rs'`): per-element via
     `Ideal.comap_isMaximal_of_surjective` + `IsLocalRing.isMaximal_iff`
     (comap of `𝔪 (R⧸(x))` under surjective `mkq` is a maximal ideal of
     local `R`, hence equals `𝔪 R`). Axiom-clean.
  7. **Cons via `IsRegular.cons'`**: applied, leaves goal
     `IsRegular (QuotSMulTop x R) (rs'.map mkq) = IsRegular (QuotSMulTop x R)
     rs'_q` (after `rw [hmkmap]`).
- **Result**: PARTIAL — all of steps 1–6 axiom-clean; step 7 leaves a
  single inline `sorry` at L1093 for the R⧸(x)-module bridge between
  `R ⧸ Ideal.span {x}` (IH-shape) and `QuotSMulTop x R = R ⧸ (x • ⊤)`
  (cons'-shape). This bridge is a **technical bookkeeping sorry** —
  attempted via `LinearEquiv.isRegular_congr` over `R⧸(x)` with
  `Submodule.quotEquivOfEq` from `Submodule.ideal_span_singleton_smul`, but
  Mathlib's `quotEquivOfEq` is R-linear and `LinearEquiv.isRegular_congr`
  requires the implicit ring of `IsRegular` to match the LinearEquiv's
  scalar ring (here `R⧸(x)`, not `R`). Future iter can close this in
  ~10-20 LOC by constructing an `R⧸(x)`-linear equiv via
  `QuotSMulTop.mem_annihilator` (which gives that the R-action factors
  through `R⧸(x)` on `QuotSMulTop x R`, allowing the R-linear equiv to be
  upgraded to `R⧸(x)`-linear).

### Lemmas / tactics that worked
- `Ideal.comap_isMaximal_of_surjective` + `IsLocalRing.isMaximal_iff` —
  canonical 4-LOC closure for "preimage of `𝔪(quotient)` is `𝔪(local)`".
  Add to Knowledge Base.
- `Function.surjInv` + `Function.surjInv_eq` for clean list lifts through
  surjective ring homs (avoids `Quotient.out` dependent-type quirks).
- `List.map_congr_left` + `hg` for the section-identity rewrite (cleaner
  than `simp_rw` after `List.map_map`).

### Lemmas / tactics that DID NOT work
- `LinearEquiv.isRegular_congr` over `R⧸(x)` with R-linear
  `Submodule.quotEquivOfEq` — type mismatch on implicit scalar ring.
- `convert hreg_q using 1/2` — leaves heterogeneous-equality goals on
  AddCommGroup / Module instance fields (not a clean route).
- Direct `exact hreg_q` — `Sequence.IsRegular (R ⧸ Ideal.span {x}) rs'_q ≠
  Sequence.IsRegular (QuotSMulTop x R) rs'_q` (the two M's are not defeq
  even though they're equal as sets via the `ideal_span_singleton_smul`
  bridge).

### Searched but absent from Mathlib
- `isRegular_map_algebraMap_iff` (only `isWeaklyRegular_map_algebraMap_iff`
  shipped; the full IsRegular version would handle the R-vs-R⧸(x) bridge
  if it existed).
- Direct `IsRegularLocalRing` → `IsRegular` or → `IsDomain` lemmas.
- Koszul-complex acyclicity (no `Mathlib/.../Koszul*` files at b80f227).

---

## `auslander_buchsbaum_formula` (L835, UNCHANGED)

Per iter-185 directive: **DROP from Lane G targets** (off critical path
for A.4.a per iter-184 lean-vs-blueprint-checker `iter184-auslander`).
The downstream consumer `CohenMacaulay.of_regular` uses
regular-sequence-length = Krull-dim, not the AB formula directly. AB
formula closure is iter-186+ work or Mathlib upstream.

---

## Blueprint marker readiness

- `def:depth` (L121, `RingTheory.Module.depth`) — already `\leanok` (closed
  iter-180 Lane H).
- `lem:depth_via_ext` (L106, `depth_eq_smallest_ext_index`) — already
  `\leanok` (closed iter-184 Lane G PRIMARY HARD BAR).
- `def:projective_dimension` (L168, `Module.projectiveDimension`) — already
  `\leanok` (closed iter-178 Lane 7).
- `lem:depth_short_exact_sequence` (L209, `depth_of_short_exact`) —
  propagated kernel-clean iter-184 (no `sorry` in body).
- `def:cohen_macaulay_local` (L411, `RingTheory.CohenMacaulay`) — class
  def, no body sorry.
- `thm:auslander_buchsbaum` (L268, `auslander_buchsbaum_formula`) — typed
  sorry remains (off critical path).
- `cor:regular_cohen_macaulay` (L437, `CohenMacaulay.of_regular`) — uses
  `exists_isRegular_of_regularLocal`, which now reduces to the Helper 1
  typed sorry (instead of `regularLocal_inductive_step` bare sorry).
  Blueprint marker status: same as previous iter (transitively reaches a
  typed sorry).

No blueprint marker changes needed — `\leanok` deterministic-sync handles
the propagation.

---

## Next-iter suggestions (Lane G continuations)

1. **iter-186+ Helper 1 close path (a)**: formalize Stacks 00NQ
   (`IsRegularLocalRing → IsDomain`) — ~300 LOC of project work. Mathlib
   `biUnion_associatedPrimes_eq_compl_nonZeroDivisors` gives the
   "non-zero-divisor = not in Ass(R)" bridge; the embedded-prime
   characterization of regular local rings (Matsumura Th. 14.3) gives
   `Ass(R) = {min primes}`, hence in dim ≥ 1 case `𝔪 ∉ Ass(R)`. Combined
   with prime avoidance + the additional `𝔪 \ 𝔪²` minimal-generator
   extraction. Could be its own iter-186 dedicated lane.

2. **iter-186+ Helper 1 close path (b)**: formalize Stacks 00NU + Krull's
   PIT for quotient regularity. Mathlib has
   `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` (Krull's PIT
   half); the spanFinrank shift `(maximalIdeal R').spanFinrank = k` from
   `(maximalIdeal R).spanFinrank = k + 1` requires picking a minimal generator
   set of `𝔪` containing `x` and quotienting out `x`. ~200 LOC. Can be
   pursued in parallel with (a).

3. **iter-186+ bridge close**: the inline `sorry` at L1093
   (`regularLocal_inductive_step` body) is ~10-20 LOC of pure bookkeeping.
   Construction path: build an `R⧸(x)`-linear equiv
   `(R ⧸ Ideal.span {x}) ≃ₗ[R⧸(x)] QuotSMulTop x R` by:
   - Note `Submodule.ideal_span_singleton_smul x ⊤ : Ideal.span {x} • ⊤ = x • ⊤`
     gives equality of the two R-submodules of R.
   - `Submodule.quotEquivOfEq` gives an R-linear equiv.
   - Upgrade to R⧸(x)-linear: `QuotSMulTop.mem_annihilator` shows
     `x ∈ Module.annihilator R (QuotSMulTop x R)`, so the R-action
     factors through `R⧸(x)`; same for the LHS quotient. Any R-linear
     equiv between two R⧸(x)-modules (where R-action factors through
     R⧸(x)) is automatically R⧸(x)-linear (construct the linearity field
     by hand or use Mathlib helpers).
   - Then `LinearEquiv.isRegular_congr` over `R⧸(x)` with this equiv on
     `rs'_q` closes the goal.

4. **`auslander_buchsbaum_formula` body** (L835) — iter-200+ substrate.
   4-8 iters of multi-iter Mathlib formalization (minimal-finite-free-
   resolutions + Stacks 00MF + snake lemma + depth-drops-by-one). Off
   critical path per iter-184 lean-vs-blueprint-checker.

---

## Iter-186 plan-phase context

- Lane G next iter should pick the cheapest of (1)/(2)/(3) above. Path (3)
  is the cheapest (10-20 LOC, no substrate) and gets `regularLocal_inductive_step`
  to axiom-clean (sorry count 3 → 2). Then Lane G iter-187 onwards can
  attack (1) or (2) for full closure.
- The new Helper 1 has the precise signature needed; if Mathlib ships
  Stacks 00NQ (`IsRegularLocalRing → IsDomain`) at b8XX+, Helper 1 closes
  in ~40 LOC using Mathlib's `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`.
