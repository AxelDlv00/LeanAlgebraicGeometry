# Lean ↔ Blueprint Check Report

## Slug
ab-iter199

## Iteration
199

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

---

## Per-declaration

All nine `\lean{...}`-tagged declarations in the chapter were audited. Namespace
analysis was performed by tracing `namespace`/`end` pairs through the full Lean
file:

- `namespace RingTheory` opens at L108 (closes L155) and again at L192 (closes L2836).
- `namespace Module` opens at L168 (closes L190) and again at L194 (closes L1278).
- `namespace CohenMacaulay` opens at L1557 (closes L2834), inside `RingTheory`.

---

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`, L69 of tex)
- **Lean target exists**: yes — `noncomputable def depth` at Lean L146, in `RingTheory.Module`.
- **Signature matches**: yes — takes `(Ideal R) → (M : Type v) → ℕ∞`; body is the sSup of
  regular-sequence lengths (with the `I • ⊤ = ⊤` sentinel for ∞), matching the Stacks 00LF
  definition in the blueprint prose exactly.
- **Proof follows sketch**: N/A (definition, no proof block in blueprint).
- **Notes**: Axiom-clean (no sorry). `\leanok` on statement and proof correctly present.

---

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`, L108)
- **Lean target exists**: yes — `theorem depth_eq_smallest_ext_index` at Lean L295, in `RingTheory.Module`.
- **Signature matches**: yes — `(n : ℕ) : (n : ℕ∞) ≤ depth 𝔪 M ↔ ∀ i < n, ∀ e : Ext κ M i, e = 0`.
  This is the depth-bound ↔ Ext-vanishing form the chapter says is "most convenient for inductive
  proofs", matching the blueprint prose and the Stacks 00LP encoding.
- **Proof follows sketch**: yes — the proof (L295–619) follows the LES-of-Ext blueprint sketch with
  base case and inductive step both closed. Former "residual sorry" branches (iter-183 docstring)
  were closed by iter-184; proof is now sorry-free.
- **Notes**: `\leanok` on statement and proof both present and accurate.

---

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`, L173)
- **Lean target exists**: yes — `noncomputable def projectiveDimension` at Lean L186, in
  top-level `Module` namespace.
- **Signature matches**: yes — `(R : Type u) [Ring R] (_M : Type u) → WithBot ℕ∞`, body is
  `CategoryTheory.projectiveDimension (ModuleCat.of R _M)`. Matches the blueprint's description
  of the categorical re-export.
- **Proof follows sketch**: N/A (definition).
- **Notes**: Axiom-clean. `\leanok` correct.

---

### `\lean{RingTheory.Module.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`, L215)
- **Lean target exists**: yes — `theorem depth_of_short_exact` at Lean L676, in `RingTheory.Module`.
- **Signature matches**: yes — three crosswise depth inequalities packaged as a conjunction, for a SES
  of nonzero finite modules over a Noetherian local ring. Matches Stacks 00LE and the chapter's
  enumerated list exactly.
- **Proof follows sketch**: yes — proof (L676–795) routes through `depth_eq_smallest_ext_index` +
  LES of `Ext^*(κ, -)`, as the blueprint prose says.
- **Notes**: Axiom-clean. `\leanok` on statement and proof both accurate.

---

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`, L278)
- **Lean target exists**: yes — `theorem auslander_buchsbaum_formula` at Lean L1452, in `RingTheory`.
- **Signature matches**: yes — `(n : ℕ) (_hpd : pd R M = n) : (n : ℕ∞) + depth 𝔪 M = depth 𝔪 R`.
  Matches the blueprint's `pd_R(M) + depth(M) = depth(R)` for nonzero finite `M` of finite pd.
- **Proof follows sketch**: partial — the base case `pd = 0` is closed axiom-clean (L1469–1516);
  the inductive step `pd = k+1` delegates to `auslander_buchsbaum_formula_succ_pd` (L1514–1516)
  which has a `sorry` (L1432). The blueprint proof sketch authorises both arms.
- **Notes**: Blueprint proof block carries `\leanok` (L356–359), but `auslander_buchsbaum_formula`
  transitively depends on the sorry inside `auslander_buchsbaum_formula_succ_pd`. If
  `sync_leanok` only counts sorry tokens directly present in the proof text (not through calls to
  private helpers), the `\leanok` is misleadingly present. **See minor finding M-1 below.**

---

### `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` (chapter: `lem:auslander_buchsbaum_formula_succ_pd`, L420)
- **Lean target exists**: yes — `private lemma auslander_buchsbaum_formula_succ_pd` at Lean L1398,
  in `RingTheory` namespace. Name matches exactly **but declaration is `private`**.
- **Signature matches**: yes — `(k : ℕ) (_hpd : pd R M = k+1) : (k+1 : ℕ∞) + depth 𝔪 M = depth 𝔪 R`,
  matching the blueprint's "inductive-step variant for pd = k+1" framing.
- **Proof follows sketch**: N/A for the body (it is `sorry`); the docstring correctly describes
  the four substrate gaps and iter-199 progress. **See major finding F-3 below.**
- **Notes**: Statement `\leanok` is present and correct (declaration is formalized with a sorry).
  Proof block has no `\leanok`, which is correct since the proof is not closed.

---

### `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}` (chapter: `lem:depth_drops_by_one`, L470)
- **Lean target exists**: yes — `lemma depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` at Lean
  L1020, in `RingTheory.Module`.
- **Signature matches**: yes — `(hxMem : x ∈ 𝔪) (hxReg : IsSMulRegular M x) :
  depth 𝔪 (QuotSMulTop x M) + 1 = depth 𝔪 M`. Exactly matches the blueprint's
  `depth(M/xM) + 1 = depth(M)` for `x ∈ 𝔪` regular on `M`.
- **Proof follows sketch**: yes — routes through `depth_eq_smallest_ext_index` + LES on
  `0 → M →[x] M → M/xM → 0`, using the `[x]`-kills-Ext helper, as the blueprint proof sketch says.
- **Notes**: Axiom-clean. Name matches exactly. `\leanok` on both statement and proof is correct.

---

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`, L644)
- **Lean target exists**: yes — `class CohenMacaulay` at Lean L1538, in `RingTheory`.
- **Signature matches**: yes — `Prop`-valued typeclass with single field
  `depth_eq_krullDim : (depth 𝔪 R : WithBot ℕ∞) = ringKrullDim R`. Matches the blueprint's
  `depth(R) = dim(R)` definition.
- **Proof follows sketch**: N/A (definition).
- **Notes**: Axiom-clean. `\leanok` correct.

---

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`, L679)
- **Lean target exists**: yes — `instance of_regular` at Lean L2794, in `RingTheory.CohenMacaulay`.
- **Signature matches**: yes — `[IsRegularLocalRing R] : CohenMacaulay R`. Matches the blueprint's
  "every regular Noetherian local ring is Cohen–Macaulay".
- **Proof follows sketch**: yes — proof (L2794–2832) uses `exists_isRegular_of_regularLocal` for
  the lower bound and `length_le_ringKrullDim_of_isRegular` for the upper bound, then equates
  depth and spanFinrank (= ringKrullDim for regular local). This matches the blueprint's
  "regular-sequence argument" proof sketch. The only residual sorry is in the private helper
  `isDomain_of_regularLocal` → `notMem_minimalPrimes_of_regularLocal_succ` chain, reached
  through `exists_isSMulRegular_quotient_isRegularLocal_succ` → `exists_isRegular_of_regularLocal`.
  The `notMem_minimalPrimes_of_regularLocal_succ` body is fully written (no sorry keyword present);
  `isDomain_of_regularLocal` is also fully written. The file's single sorry is only in
  `auslander_buchsbaum_formula_succ_pd`.
- **Notes**: Axiom-clean (through `exists_isRegular_of_regularLocal` which is fully closed).
  `\leanok` on statement and proof are correct.

---

## Red flags

### Placeholder / suspect bodies
- `RingTheory.auslander_buchsbaum_formula_succ_pd` at Lean L1432: body is `:= sorry`. However,
  the blueprint explicitly authorises this gap (statement `\leanok` present; proof block has no
  `\leanok`; the chapter's subsection §subsec:succ_pd_gap_sequence documents the four substrate
  gaps and iter budget). This sorry is **blueprint-authorized** and not a red flag by the checker's
  rules.

### Excuse-comments
None found. Inline comments are progress-tracking notes ("`iter-199 Lane AB substrate progress...`")
that accurately reflect the Lean state.

### Axioms / Classical.choice on non-trivial claims
None. The file uses `Classical` via `open Classical in` inside `depth` (L148) for the `if`-branch,
which is appropriate for a noncomputable supremum definition.

---

## Unreferenced declarations (informational)

Public declarations in the Lean file without a `\lean{...}` blueprint pin:

| Declaration | Lean location | Nature |
|---|---|---|
| `RingTheory.Module.depth_eq_of_linearEquiv` | L814 | Helper: depth preserved under linear equiv. Used in `auslander_buchsbaum_formula` base case. |
| `RingTheory.Module.depth_pi_const_eq_depth_of_nonempty` | L988 | Helper: `depth(ι → M) = depth(M)`. Used in `auslander_buchsbaum_formula` base case. |
| `RingTheory.Module.exists_isSMulRegular_of_one_le_depth` | L1136 | Helper: positive depth → regular element exists. |
| **`RingTheory.Module.exists_minimalSurjection_finite_localRing`** | **L1198** | **iter-199 gap-(1) first-step substrate. Public and substantive. See major finding F-1.** |
| `RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal` | L2742 | Known pre-existing gap flagged in blueprint NOTE at tex L656–673. |

All others are `private` helpers.

---

## Findings

### F-1 (major): Missing `\lean{...}` pin for `RingTheory.Module.exists_minimalSurjection_finite_localRing`

**Description.** The iter-199 new helper `exists_minimalSurjection_finite_localRing` (Lean L1198,
~80 LOC, axiom-clean) is a **public** declaration in `RingTheory.Module` and the first-step
substrate for gap (1) (minimal-resolution carving, Stacks `lemma-add-trivial-complex`). The
blueprint's new `\subsection{Inductive-step substrate}` (`\label{subsec:succ_pd_gap_sequence}`,
tex L494–628) discusses gap (1) in prose and the per-gap table, but does **not** include a
`\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}` pin.

**Impact.** The lean-vs-blueprint checker cannot bidirectionally verify this declaration. The
blueprint reader has no navigation anchor from the gap-(1) prose to the Lean helper.

**Recommended fix.** Add to the blueprint, inside `\subsec{subsec:succ_pd_gap_sequence}` (after
the per-gap table or as a new `\begin{lemma}...\end{lemma}` block):

```latex
\begin{lemma}[Minimal surjection from a local ring — first step of gap (1)]
  \label{lem:minimal_surjection_finite_localRing}
  \lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}
  \leanok
  For a commutative local ring $(R, \mathfrak m)$ and a finitely generated
  $R$-module $M$, there exists a surjective $R$-linear map
  $f : (R^n) \to M$ of minimal rank $n = \dim_\kappa(\kappa \otimes_R M)$
  whose kernel is contained in $\mathfrak m \cdot R^n$.
\end{lemma}
```

---

### F-2 (major): Per-gap table status for gap (1) is stale (`absent` → should be `partial`)

**Description.** The per-gap table at tex L559–575 shows gap (1) Mathlib status as
`absent`. The iter-199 prover work landed `exists_minimalSurjection_finite_localRing` as an
axiom-clean first-step substrate for gap (1). The Lean docstring at L1344–1368 explicitly records
`PARTIAL iter-199` for gap (1). The blueprint table has not been updated to reflect this.

**Impact.** A reader following the blueprint's gap table would incorrectly believe gap (1) has no
project-side progress as of this iteration.

**Recommended fix.** Update the table row for gap (1) in `\subsec{subsec:succ_pd_gap_sequence}`:

```latex
(1) & Minimal-resolution carving  & 80--120 & 1--2
    & \textbf{partial iter-199: first-step} \texttt{exists\_minimalSurjection\_finite\_localRing}
    & none \\
```

---

### F-3 (major): `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` pins a `private` declaration

**Description.** At blueprint tex L420:
```latex
\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}
```
The corresponding Lean declaration at L1398 is:
```lean
private lemma auslander_buchsbaum_formula_succ_pd
```
In Lean 4, `private` declarations are inaccessible from other files (they receive a mangled
internal name). A `\lean{...}` pin on a private declaration cannot be verified by downstream
Lean tools (e.g. `lean_verify`, `#check` from other files, blueprint-doctor's name-resolution
pass) because the public name `RingTheory.auslander_buchsbaum_formula_succ_pd` does not exist
in the global environment from outside the file.

**Options:**
1. Remove `private` from `auslander_buchsbaum_formula_succ_pd` in the Lean file (making it
   accessible and verifiable — consistent with its blueprint pin).
2. Remove the `\lean{...}` pin from the blueprint and document it only in prose (keeping
   the declaration private as an implementation detail).

Option (1) is cleaner given that the blueprint has a full `\begin{lemma}...\end{lemma}` block
with a proof sketch for this declaration.

---

### M-1 (minor): `\leanok` on proof block of `thm:auslander_buchsbaum` is potentially misleading

**Description.** The blueprint proof block of `thm:auslander_buchsbaum` (tex L355–413) carries
`\leanok` (tex L358). However, `auslander_buchsbaum_formula` (Lean L1452) calls
`auslander_buchsbaum_formula_succ_pd` (L1398) whose body is `sorry`. This makes
`auslander_buchsbaum_formula` transitively sorry-dependent.

**Root cause.** `sync_leanok` likely counts `sorry` tokens directly present in the declaration's
proof text, not transitively through called private helpers. Since `auslander_buchsbaum_formula`'s
proof body does not contain the word `sorry` (it calls a helper), `sync_leanok` marks it `\leanok`.
This is a known limitation of syntactic sorry-counting.

**Impact.** Low — a reader could infer from the sorry count (1 file-level sorry) and the gap
documentation that `auslander_buchsbaum_formula`'s proof is not fully axiom-clean. No misleading
correctness claim is made.

**Recommended fix.** This is a `sync_leanok` behavior issue, not a prover or blueprint-writer error.
No action required from blueprint-writing or proving agents. Can be addressed by upgrading
`sync_leanok` to use transitive sorry tracking.

---

## Blueprint adequacy for this file

- **Coverage**: 9/9 pinned `\lean{...}` declarations match their Lean counterparts (by name and
  signature). Additionally, `exists_minimalSurjection_finite_localRing` is an unpin-ned public
  substantive declaration (finding F-1). The pre-existing `exists_isRegular_of_regularLocal` gap
  is already documented in the chapter NOTE (tex L656–673) as a known pin-pending item.
- **Proof-sketch depth**: adequate for all closed declarations. The `subsec:succ_pd_gap_sequence`
  adequately describes the four gap-substrate items and their dependencies. Gap (1) prose does not
  mention the new iter-199 partial landing (finding F-2).
- **Hint precision**: partial — 8/9 pins are precise (public declarations, name matches verified).
  1/9 pins a `private` declaration (finding F-3), which is an accessibility precision failure.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Add `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}` pin with a short
     lemma block inside `\subsec{subsec:succ_pd_gap_sequence}` (resolves F-1).
  2. Update per-gap table row for gap (1) from `absent` to `partial iter-199` (resolves F-2).
  3. Either remove `private` from the Lean declaration or remove the `\lean{...}` pin from the
     blueprint for `auslander_buchsbaum_formula_succ_pd` (resolves F-3).

---

## Severity summary

| Finding | Severity | Description |
|---|---|---|
| F-1 | **major** | `exists_minimalSurjection_finite_localRing` missing blueprint pin |
| F-2 | **major** | Per-gap table gap (1) status stale (`absent` should be `partial`) |
| F-3 | **major** | `\lean{...}` pin on `private` declaration `auslander_buchsbaum_formula_succ_pd` |
| M-1 | **minor** | `\leanok` on `thm:auslander_buchsbaum` proof misleading (indirect sorry) |

No **must-fix-this-iter** findings: the single sorry in `auslander_buchsbaum_formula_succ_pd`
is blueprint-authorized (gaps (1)–(3) documented, iter budget 5–8, gap (4) CLOSED). All
signatures match their blueprint prose. No fake/placeholder bodies, no excuse-comments, no
unauthorized axioms.

**Overall verdict**: Lean file is faithful to the blueprint on all nine pinned declarations; three
major blueprint-side gaps require a short chapter touch — add the iter-199 pin, update the gap
table status, and resolve the private/pin inconsistency for `auslander_buchsbaum_formula_succ_pd`.
