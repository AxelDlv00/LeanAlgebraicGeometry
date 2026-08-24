# DD-F probe verdict — P-fib persistence (RECON/probe)

*Date 2026-07-16. Lane DD-F (the P-fib persistence heart), DAT-D campaign.
Status: **COMPLETE — VERDICT GREEN**. Author: Fable probe agent (continuation
after two session-limit deaths; no prior on-disk state).*

BINDING references: `informal/dat-d-worksheet.md` §3.2–3.3 (P-fib, F1–F4),
§5 DD-F probe gate, §6 risk 1; addendum commit 5ee7fd62c (DAT-0b/DAT-5
spellings); DD-0 exports a0509aa95 (SectionBound) + f17afc913 (WindowLedger).

## Question

P-fib (worksheet §3.2): over a field `K ⊇ k'`, given `K_M ⊆ H_M ⊗ K`,
`K' ⊆ H_{M+s} ⊗ K` of codimension exactly `g` with `μ(H_s ⊗ K_M) ⊆ K'` (the
carve `(♦)`), there is a UNIQUE effective divisor `D`, `deg D = g`, with
`K_M = H⁰(𝒪(MF − D))` and `K' = H⁰(𝒪((M+s)F − D))`. The probe must decide the
route F1→F4, above all **F3** (lane rigidity endgame) — the campaign's single
open mathematical step. Gate: GREEN = F3 closed; AMBER = DD-Φ; RED = escalate.

## Inputs read

- DD-0 (ii) WindowLedger (`RiemannRoch/WindowLedger.lean`, f17afc913): constants
  `windowBound b` (:107, spec :112), `windowδ` (:120, `1 ≤ δ` :123,
  `deg F = δ` :131), `windowS_choice s` (:150, spec :154 — `(s−1)δ ≥ b+2g`),
  `windowM_choice M` (:174, spec :177). Window lemmas BY NAME: embedding
  (:240,:249), multiplier (:261), normalization ± shift (:271,:281 for
  `deg D ≤ 2g`), **lane windows** (:295,:311 — `h¹(𝒪(A·F − D − j·P)) = 0` for
  `deg D ≤ 2g`, `j ≤ g+1`), multiplier lane (:332), rank forms
  `h⁰ = A·δ + χ(𝒪_Y)` (:345,:352,:362).
- DD-0 (i) SectionBound (`RiemannRoch/SectionBound.lean`, a0509aa95):
  `h1`-peeling kit (:67,:89,:98,:115,:159), effective witness
  `exists_effective_of_h0_pos` (:175), section bound `h⁰ ≤ max 0 (deg A + 1)`
  (:235, `h⁰(𝒪_X)=1` form :248, linear form :258). F1's `ℓ ≤ 2g` input.
- Worksheet §3.3 route F1–F4 + §3.6(a) pencil counterexample (the probe must
  attack full-`H_s` rigidity, not the pencil weakening).

## Findings

Notation: `N := MF − D`, `V₀ := H⁰(N)`, `W₀ := H⁰(N + sF)`, `ℓ := deg D`,
`c := g − ℓ`, `r_A := Aδ + 1 − g` (ledger rank forms). All `h¹`-vanishing claims
below were checked against the ledger arithmetic: `windowM_spec` gives
`(M−s)δ ≥ b + 2g + ((g+2)(s+1) − s)δ ≥ b + 2g`, so every window used sits at
degree ≥ b + 2g minus a defect ≤ 2g, i.e. ≥ b, dischargeable by
`windowBound_spec` + `h1_add_effective_le` (SectionBound:115) alone.

### (1) F1 verified (no surprises)

`D := bd(K_M)` (pointwise ord-minima; support finite since bounded by any one
`div f₀ + MF`). `K_M ⊆ H⁰(MF − D)` with **no residual base point** (bd exact).
Bounds: `ℓ ≤ 2g` from the section bound (`h0_divisorSheaf_le_max`,
SectionBound:235): `r_M − g = dim K_M ≤ h⁰(MF − D) ≤ Mδ − ℓ + 1`; then with
`ℓ ≤ 2g` the normalization window (:271) makes `h⁰(MF − D) = r_M − ℓ` exact, and
`r_M − g ≤ r_M − ℓ` gives `ℓ ≤ g`, `c ≥ 0`. As worksheet F1. ✓

### (2) THE PROBE'S MAIN FINDING — F3 closes by a shorter route

The lane/Macaulay endgame of worksheet §3.3 F3 is NOT needed. The whole of
F3 + F4 reduces to ONE span lemma, proved below field-agnostically:

> **(F3-core, the bpf-span lemma.)** Let `K ⊆ H⁰(N)` be a subspace of
> codimension `c ≤ g` in `H⁰(N)` (here `N = MF − D`, `deg D = ℓ ≤ g`) whose
> base divisor relative to `N` is ZERO (F1 normalization). Then
> `span(H_s · K) = H⁰(N + sF)` — the FULL window, over ANY field `K ⊇ k'`.

Consequence (P-fib in three lines): `(♦)` says `span(H_s·K_M) ⊆ K′`, so
`dim W₀ = r_{M+s} − ℓ ≤ dim K′ = r_{M+s} − g`, forcing `ℓ ≥ g`, hence `ℓ = g`,
`c = 0`. Then `K_M = H⁰(MF − D)` (containment + equal dims `r_M − g`), and
`K′ = H⁰((M+s)F − D)` (contains the full span, equal dims `r_{M+s} − g`).
Uniqueness: `D = bd(K_M)` is determined by `K_M`; conversely
`bd(H⁰(MF − D̃)) = D̃` for effective `D̃` of degree `g` (per-point: for
`deg x ≤ g` the normalization window gives the exact drop `h⁰(MF−D̃−x) =
h⁰(MF−D̃) − deg x < h⁰`; for `deg x > g` the section bound already forces
`h⁰(MF−D̃−x) < h⁰(MF−D̃)`). So `D̃ = D`. F4's surjectivity IS F3-core at
`c = 0`. ✓

### (3) Proof of F3-core, step by step (every input named)

Suppose `Λ ∈ W₀^*` kills `span(H_s·K)`; show `Λ = 0` (then span = W₀, since
span ⊆ W₀ is immediate from ord calculus).

**(3a) The annihilator map.** `h ↦ Λ∘μ_h` is linear `H_s → ann_{V₀^*}(K)`,
and `dim ann(K) = c` (K has exact codim c in V₀). So its kernel
`N_L := {h ∈ H_s : Λ(h·V₀) = 0}` has codimension ≤ c ≤ g in `H_s`.

**(3b) The base locus of `N_L` is small.** `E := bd(N_L)` (rel `sF`). Then
`N_L ⊆ H⁰(sF − E)`, so by the section bound (SectionBound:235) and the exact
rank `dim H_s = r_s` (WindowLedger:362):
`sδ + 1 − g − c ≤ dim N_L ≤ sδ − deg E + 1`, giving `deg E ≤ g + c ≤ 2g`.

**(3c) `Λ` kills `H⁰(N + sF − E)` — the finite-field-safe Koszul step.**
Choose finitely many `h₁, …, h_m ∈ N_L` whose pointwise ord-minimum realizes
`E` exactly: `h₁ ≠ 0` arbitrary, then for each of the finitely many closed
points `x` of `supp(div h₁ + sF − E)` an achiever `h_x ∈ N_L` with
`ord_x h_x + (sF)_x = E_x` (exists: bd is a pointwise min). Then
`⋀_i (div h_i + sF) = E`. For each `i ≥ 2` set
`E_i := (div h₁ + sF) ⊓ (div h_i + sF) ≥ E` (Finsupp min). Pairwise pencil
Koszul with base: the sheaf sequence
`0 → 𝒪(N − sF + E_i) → 𝒪(N)² → 𝒪(N + sF − E_i) → 0` ((−h_i,h₁) then
(h₁,h_i); right-exact because `div h₁ ∧ div h_i = E_i` exactly; kernel by
gcd calculus in the Dedekind chart rings). `H⁰`-exactness on the right:
cokernel ↪ `H¹(N − sF + E_i) = 0` — `h¹((M−s)F − D) = 0` by
`windowBound_spec` (degree `(M−s)δ − ℓ ≥ b + 2g − ℓ ≥ b`) and adding the
effective `E_i` only shrinks `h¹` (`h1_add_effective_le`, SectionBound:115).
So `h₁V₀ + h_iV₀ = H⁰(N + sF − E_i)`. Summing over `i` with the
**sum-intersection divisor lemma**: `H⁰(A−E₁) ∩ H⁰(A−E₂) = H⁰(A − E₁⊔E₂)`
(pure ord calculus, sup of Finsupps) plus exact window dimension counts gives
`H⁰(A−E₁) + H⁰(A−E₂) = H⁰(A − E₁⊓E₂)` at every level used (all degrees ≥ b);
iterating, `span(Σ_i h_iV₀) = H⁰(N + sF − ⋀_i E_i) = H⁰(N + sF − E)`.
All `h_i ∈ N_L`, so `Λ` kills it. **No generic pencil, no infinite-field
assumption, no syzygy bundle** — pairwise line-bundle Koszul only.

**(3d) So `Λ` is supported on `E`.** `h¹(N + sF − E) = 0` (degree ≥ b as
above), so `W₀/H⁰(N+sF−E) ≅ Γ(𝒪(N+sF)|_E) =: M′_E`, a free rank-1 module
over the Artinian algebra `A_E := Γ(𝒪_E)` of dimension `deg E ≤ 2g`
(ChartColength vocabulary: colength module at the finite subscheme `E`).
`Λ` factors through `Λ_E ∈ (M′_E)^*`, and `M′_E = L_s ⊗_{A_E} L_N` with
`L_s := Γ(𝒪(sF)|_E)`, `L_N := Γ(𝒪(N)|_E)` invertible (free rank 1: `E`
Artinian semilocal).

**(3e) The Artinian unit-ideal endgame (where FULL `H_s` is spent).**
- `H_s ↠ L_s` is onto: `h¹(sF − E) = 0` since `sδ − deg E ≥ sδ − 2g ≥ b + δ`
  (windowS_spec). [Pencil-only fails HERE — a pencil's image in `L_s` is
  2-dimensional, never all of `L_s` once `δ ≥ 2`; this reproduces worksheet
  §3.6(a)'s counterexample mechanism exactly, as the gate demands.]
- `X := image(K → L_N)` generates `L_N` as an `A_E`-module: `K` has NO base
  point rel `N` (F1), so at each `x ∈ supp E` the image of `K` in
  `L_N ⊗ κ(x)` is nonzero; `A_E = ∏_x A_x` local Artinian factors, so the
  submodule `A_E·X ⊆ L_N ≅ A_E` corresponds to an ideal in no maximal ideal:
  `A_E·X = L_N` (Nakayama per local factor).
- Restriction is multiplicative, so the `E`-image of `span(H_s·K)` contains
  `span(L_s · X) ⊇ gen(L_s)·(A_E·X) = M′_E` — everything. `Λ_E` kills it, so
  `Λ_E = 0`, so `Λ = 0` on `W₀`. ∎

**Consistency checks run:** (i) `E` may meet `supp F` — harmless, (3d)/(3e)
never identify `L_s` with `A_E` multiplicatively, only as a free module.
(ii) Residue fields of degree > 1: the rank-1 factorization forcing in the
naive c=1 functional argument is subsumed — no rational-point assumption
anywhere. (iii) The lemma is FALSE for unbounded `c` (tiny bpf pencils);
codim ≤ g enters exactly and only at (3b) via `deg E ≤ g + c ≤ 2g`, which the
window budget `(s−1)δ ≥ b + 2g` was designed to absorb. The worksheet's window
ledger is EXACTLY sufficient — no constant needs revisiting.

## Verdict

**GREEN — F3 is closed** (as mathematics, at full proof rigor with every
cohomological input named against the landed ledger), by a route SHORTER than
the worksheet's designed one:

- The lane model (worksheet F2) and the Macaulay-type monotone-profile
  induction (the feared F3 endgame) are NOT needed. F3+F4 collapse into the
  single bpf-span lemma (Findings §2–3), whose proof spends: DD-0's section
  bound + `h¹`-effective-monotonicity, `windowBound_spec` arithmetic, the
  explicit pairwise Koszul, and the Artinian unit trick at the base locus `E`
  of the annihilator kernel `N_L`.
- The proof is valid over EVERY field `K ⊇ k'` including finite fields (the
  classical generic-bpf-pencil step is replaced by finitely many explicit
  achiever sections + the sum-intersection lemma) — no base change to `K̄`,
  which DD-R's residue-field consumption would otherwise have forced.
- The §3.6(a) pencil counterexample is respected: full `H_s` is spent
  precisely at (3e) `H_s ↠ L_s`, the exact point where the pencil dies.
- DD-Φ (matrix-chart fallback) does NOT need to be opened. Sym^g stays RED,
  untouched.

Honest scope: "closed" = complete verified informal proof with all windows
checked against `WindowLedger`/`SectionBound` names and arithmetic; NO Lean
formalization of F3 exists yet. Probe budget went to the mathematics (per
lane brief: the verdict IS the deliverable).

## Obstructions

None mathematical. Lean-infrastructure inventory for the DD-F formalization
(all elementary, none open; sizes per recon convention):

1. `bd` — base divisor of a finite-dim subspace of `H⁰(𝒪(A))` (ord-minima,
   finiteness, achiever lemmas, `K ⊆ H⁰(A − bd K)`). [M]
2. Section multiplication `H⁰(A) × H⁰(B) → H⁰(A+B)` chart-wise on the
   two-chart Čech `H⁰` (`Sheaf.HModule … 0`), + inclusion transports for
   `A ≤ B` (FLV exhaustion pattern). [S→M]
3. Restriction-to-finite-subscheme algebra: `A_E`, `L_s`, `L_N`, `M′_E`,
   surjectivity from `h¹`-windows via the slice SES, freeness rank 1 over
   Artinian semilocal, multiplicativity (ChartColength vocabulary). [M→L —
   the heaviest brick]
4. Pairwise Koszul SES + `H⁰`-right-exactness + sum-intersection lemma. [M]
5. Functional bookkeeping (`ann(K)`, `h ↦ Λ∘μ_h`, `codim N_L ≤ c`) — pure
   linear algebra. [S]
6. ~3 named window addenda (`h¹((M−s)F − D) = 0`, `h¹(sF − E) = 0` for
   `deg E ≤ 2g`, exact `h⁰` at the levels used). Ledger discipline: these
   belong in `WindowLedger.lean` (DD-0's file, now closed) — ownership call
   for the orchestrator: either a DD-F-owned `WindowLedgerF3.lean` extension
   or a sanctioned append. [S]
7. Assembly F1 + F3-core + F4 + uniqueness. [M]

Total estimate: L→XL staged, mechanical; no step needs banned machinery, no
scheme appears (P-fib stays field-level module algebra, discipline (4) met).

Grounding pass on the inventory (grep-verified this probe): `divisorSheaf`
sections ARE rational functions with pole bounds (`divisorSections`,
`RiemannRoch/DivisorSheaf.lean:324–331`), so brick 2's multiplication is
honest function-field multiplication + one ord-inequality lemma; inclusion
transports for `D ≤ D'` already exist (`divisorPresheafLE`, :339); the
`H⁰ ↔` sections bridge is `HModule.linearEquiv₀`
(`Cohomology/ModuleKSheaf.lean:152`); brick 3's chart-level quotient
vocabulary is `ChartColength.lean` (`finrank_quotient_span_section` :411,
Dedekind charts :126, `toAdd_ordZ_eq_count_factors` :278); the rank anchor is
`FLVClass.lean:412`. The estimates above stand.

## Remainder

- Formalization of bricks 1–7 (next DD-F sessions; suggested order 2→3→1→4→5
  →6→7 so the heaviest seam (3) is probed first with the smallest context).
- Worksheet bookkeeping for the campaign designer: F2's lane model is now
  OPTIONAL (kept as fallback vocabulary; nothing downstream should build it
  speculatively); DD-R and DD-4 consume P-fib exactly as worksheet §3.4/§4.2
  state — no interface change.
- The probe gate of worksheet §5 is DISCHARGED: first deep brick attempted,
  field-level only, verdict GREEN inside the two-session budget.
