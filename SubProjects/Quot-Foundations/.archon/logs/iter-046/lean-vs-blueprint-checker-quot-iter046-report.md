# Lean ↔ Blueprint Check Report

## Slug
quot-iter046

## Iteration
046

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_map_basicOpen}` — no blueprint block

- **Lean target exists**: yes (L2728–L2740)
- **Signature matches**: N/A — no `\lean{...}` block in the chapter references this declaration
- **Proof follows sketch**: partial — the well-definedness prose inside `def:modules_annihilator`
  (blueprint ~L2366–L2387) describes exactly the content of this lemma (basic-open coherence of the
  annihilator family, using `lem:qcoh_section_localization_basicOpen` +
  `lem:annihilator_localization_eq_map`), and the Lean proof faithfully realizes that sketch.
  However, because the declaration has no dedicated block with `\lean{...}`, the `\leanok` machinery
  cannot track it, and there is no formal blueprint statement to check the signature against.
- **Notes**: The declaration is the `map_ideal_basicOpen` coherence workhorse for
  `def:modules_annihilator` and the key feeder into `annihilator_ideal`. It deserves a standalone
  `\begin{lemma} ... \lean{AlgebraicGeometry.Scheme.Modules.annihilator_map_basicOpen}` block
  with a single-`V`, single-`f` statement (the local coherence identity) rather than living only
  in prose.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal}` (`lem:modules_annihilator_ideal`, blueprint L2413)

- **Lean target exists**: yes (L2761–L2769)
- **Signature matches**: **no** — mismatch on the finiteness hypothesis (see detail below).
  A `% NOTE:` (blueprint L2419–L2428) already documents this and instructs the plan agent to
  rewrite the statement. The mismatch is:

  | Side | Finiteness hypothesis | Conclusion |
  |---|---|---|
  | Blueprint prose | `Module.Finite Γ(X,U) Γ(F,U)` — single open `U` | equality at that `U` |
  | Lean | `hfin : ∀ V : X.affineOpens, Module.Finite Γ(X,V) Γ(F,V)` — global | equality at every affine `U` simultaneously |

  The Lean statement is **correct** (the single-`U` form is unprovable: `ofIdeals` gives the
  largest coherent sub-sheaf, not the naïve infimum, so recovering the value at one `U` requires
  `map_ideal_basicOpen` to hold at *every* affine open). The blueprint statement is **wrong as
  written** — the single-`U` finiteness hypothesis is insufficient.

- **Proof follows sketch**: **no** — the blueprint proof (L2451–L2463) argues: "the section over
  `U` is the infimum over the basic opens `D(f) ⊆ U` of the comaps of the local annihilators; for
  `a ∈ Ann(F(U))` one checks the restriction lands in `Ann(F(D(f)))` for every `f`." This
  description is **mathematically false for `ofIdeals`**: `ofIdeals` is the largest *coherent*
  ideal sheaf ≤ the given family, not the section-wise infimum. Reading off the value at a single
  `U` via the infimum formula is incorrect.

  The actual Lean proof (L2764–L2769) follows the correct argument:
  1. Construct `I : X.IdealSheafData` with `I.ideal V = Ann_{Γ(X,V)}(Γ(F,V))`, using
     `annihilator_map_basicOpen` (which needs `hfin`) to discharge the coherence condition.
  2. Call `IdealSheafData.ofIdeals_ideal I` to get `ofIdeals I.ideal = I`.
  3. Read off `(annihilator F).ideal U = I.ideal U = Ann_{Γ(X,U)}(Γ(F,U))`.

  The `% NOTE:` calls for replacing the proof block with the `ofIdeals_ideal` assembly argument.
  That replacement is required.

- **Notes**:
  - The `\leanok` on this block is correct: the Lean declaration is closed and axiom-clean.
  - `set_option backward.isDefEq.respectTransparency false` is set immediately before the theorem
    (L2742) — this is a performance option (not a correctness bypass), acceptable.
  - The docstring (L2743–L2760) in the Lean file already carries the correct proof argument
    (ofIdeals_ideal assembly), which is a helpful reference for the blueprint rewrite.

---

## Red flags

### Placeholder / suspect bodies
*(None — both declarations have substantive, sorry-free proofs.)*

### Excuse-comments
*(None — the `% NOTE:` in the blueprint is a review-phase annotation placed by the review agent;
it correctly documents a known deviation and instructs the plan agent. It is not an "excuse
comment" on wrong code.)*

### Axioms / Classical.choice on non-trivial claims
*(None for the two declarations in scope.)*

---

## Unreferenced declarations (informational)

- `annihilator_map_basicOpen` (L2728) — no `\lean{...}` reference anywhere in the chapter. Its
  content is described only in prose within `def:modules_annihilator`. This is the finding that
  warrants promotion to a dedicated blueprint block (see severity below).

---

## Blueprint adequacy for this file (scoped to iter-046 additions)

- **Coverage**: `annihilator_ideal` has a `\lean{...}` block (`lem:modules_annihilator_ideal`).
  `annihilator_map_basicOpen` has **no** `\lean{...}` block — it is a substantive, standalone
  lemma whose mathematical content is described in prose but not formally tagged.

- **Proof-sketch depth**: **under-specified / wrong** for `lem:modules_annihilator_ideal`. The
  sketch claims the section is an infimum of comaps; that is not how `ofIdeals` works. The sketch
  for `def:modules_annihilator`'s well-definedness (which covers `annihilator_map_basicOpen`'s
  content) is adequate in prose but needs a formal lemma block.

- **Hint precision**: **wrong** for `lem:modules_annihilator_ideal` — the `\lean{...}` tag
  correctly names the declaration, but the stated informal hypothesis (single-`U`) does not match
  the Lean signature. A prover reading this blueprint would write a weaker statement that is not
  provable.

- **Generality**: the blueprint statement is **too weak** — the single-`U` finiteness assumption
  is insufficient. The Lean had to strengthen to a global finiteness assumption.

- **Recommended chapter-side actions**:
  1. **Must-fix**: Rewrite the statement of `lem:modules_annihilator_ideal` to use the global
     finiteness hypothesis `∀ V : X.affineOpens, Module.Finite Γ(X,V) Γ(F,V)` and state the
     conclusion at every affine `U` simultaneously. Remove or update the `% NOTE:` comment once
     the prose is corrected.
  2. **Must-fix**: Replace the proof sketch of `lem:modules_annihilator_ideal` with the
     `ofIdeals_ideal` assembly argument: (i) the annihilator family satisfies
     `map_ideal_basicOpen` at every affine open (by `annihilator_map_basicOpen`), so it assembles
     into an `IdealSheafData`; (ii) `ofIdeals_ideal` gives the equality; (iii) the value at `U`
     follows. Strike the false "infimum of comaps" sentence.
  3. **Major**: Add a dedicated `\begin{lemma}...\end{lemma}` block for
     `annihilator_map_basicOpen` with `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_map_basicOpen}`,
     stating the basic-open coherence identity (with single-`V`, single-`f`, single-`Module.Finite`
     hypothesis) and a `\uses{def:modules_annihilator, lem:annihilator_localization_eq_map,
     lem:qcoh_section_localization_basicOpen}` clause.

---

## Severity summary

| Finding | Target | Severity |
|---|---|---|
| Blueprint statement of `lem:modules_annihilator_ideal` uses single-`U` finiteness — insufficient and unprovable; Lean uses global `hfin`. | `lem:modules_annihilator_ideal` prose + `\lean{...}` | **must-fix-this-iter** |
| Blueprint proof sketch of `lem:modules_annihilator_ideal` is mathematically wrong (claims section = infimum of comaps; `ofIdeals` is the largest coherent sub-sheaf, not the infimum). | `lem:modules_annihilator_ideal` proof block | **must-fix-this-iter** |
| `annihilator_map_basicOpen` has no `\lean{...}` block in the chapter; it is a substantive standalone lemma that should be formally tagged. | `def:modules_annihilator` / missing lemma block | **major** |

**Overall verdict**: The Lean code for both declarations is correct and axiom-clean; the blueprint
chapter fails in two ways — the statement of `lem:modules_annihilator_ideal` has the wrong (too
weak) finiteness hypothesis, and its proof sketch is mathematically incorrect — both already
flagged by a `% NOTE:` annotation awaiting plan-agent action; `annihilator_map_basicOpen` also
lacks a `\lean{...}` block.

2 declarations checked, 0 sorry-red-flags (both proofs are closed), 3 blueprint-side findings
(2 must-fix, 1 major).
