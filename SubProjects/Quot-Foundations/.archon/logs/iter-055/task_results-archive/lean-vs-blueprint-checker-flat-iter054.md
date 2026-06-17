# Lean ↔ Blueprint Check Report

## Slug
flat-iter054

## Iteration
054

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Directive focus: B2 chain + `gf_common_basicOpen_basis` + `genericFlatness`

The directive calls for special attention on the new B2 chain and asks for explicit
verification of the prover-reported invariant mismatch.

---

## Per-declaration: B2 chain

### `\lean{AlgebraicGeometry.gf_crossChart_basicOpen_eq}` (lem:gf_crossChart_basicOpen_eq, B2.1)

- **Lean target exists**: yes (line 2819)
- **Signature matches**: yes — takes `hmatch : g|_O = ḡ|_O` as hypothesis (the restriction-
  matched datum), and proves `X.basicOpen g = X.basicOpen ḡ`. This is exactly what the blueprint
  describes.
- **Proof follows sketch**: yes — uses `Scheme.basicOpen_res`, collapsing via `inf_eq_right` as the
  blueprint's proof says.
- **Axiom status**: axiom-clean
- **notes**: None; B2.1 is faithful.

---

### `\lean{AlgebraicGeometry.gf_section_localization_twoleg}` (lem:gf_section_localization_twoleg, B2.2)

- **Lean target exists**: yes (line 2840)
- **Signature matches**: **partial mismatch** (see below)
- **Proof follows sketch**: yes (pair of `isLocalizedModule_basicOpen` applications)
- **Axiom status**: axiom-clean
- **notes**:

  **Invariant mismatch (CONFIRMED — directive question).**
  The blueprint states B2.2 works with "a matched pair `g ∈ Γ(X, W)`, `ḡ ∈ Γ(X, Wⱼ)` cutting
  out the same basic open `D := X.basicOpen g = X.basicOpen ḡ` (as produced by B2.1)" and
  concludes that the **single group** `Γ(F, D)` carries both localization structures.

  The Lean signature is:
  ```lean
  theorem gf_section_localization_twoleg ... (g : Γ(X, W)) (gbar : Γ(X, Wj)) ... :
      IsLocalizedModule (Submonoid.powers g)   (Scheme.Modules.restrictBasicOpenₗ F g) ∧
      IsLocalizedModule (Submonoid.powers gbar) (Scheme.Modules.restrictBasicOpenₗ F gbar)
  ```
  This does **not** take `D(g) = D(ḡ)` as an assumption, and the two conclusions refer to
  `X.basicOpen g` and `X.basicOpen gbar` as potentially distinct opens. The matching of these
  two opens into **one group** is handled by the caller (by supplying `D(g) = D(ḡ)` separately).

  **Direction of the mismatch:** The blueprint's B2.2 bundles the basic-open equality into its
  precondition and states the conclusion about one group. The Lean separates the two legs and
  lets the caller supply equality. This is a **weaker presentation** in the Lean (more general:
  both legs hold independently of matching), not a wrong one. The mathematical content of each
  leg is faithfully captured; the difference is whether the matching datum is an input or is
  delegated to the caller.

  The assembly (`gf_flat_locality_assembly`, missing — see below) would need to connect
  the two legs by applying `D(g) = D(ḡ)` externally.

---

### `\lean{AlgebraicGeometry.gf_base_localization_comparison}` (lem:gf_base_localization_comparison, B2.3)

- **Lean target exists**: yes (line 2861)
- **Signature matches**: **no** — the types are different
- **Proof follows sketch**: N/A (different statement)
- **Axiom status**: axiom-clean
- **notes**:

  **Signature mismatch.** The blueprint says:
  > "the restriction `A_f → R := Γ(S, U)` realises `R` as a localization of `A_f`"
  i.e., the statement should be of type `IsLocalization ... Γ(S, U)`.

  The Lean declares:
  ```lean
  theorem gf_base_localization_comparison ... :
      letI := (S.presheaf.map (homOfLE e).op).hom.toAlgebra
      Module.Flat Γ(S, V) Γ(S, U)
  ```
  It proves **flatness** of `Γ(S, U)` over `Γ(S, V)`, not that `Γ(S, U)` is a
  **localization** of `Γ(S, V)`.

  The Lean comment at line 2852–2859 explicitly acknowledges this:
  > "weakened (flat) form of the blueprint sub-lemma — all the assembly consumes"

  This is an intentional weakening. Flatness follows from IsLocalization (localizations are
  flat), so the Lean proves a consequence rather than the stated claim. Whether the weaker
  form truly suffices cannot be verified because `gf_flat_locality_assembly` is missing from
  the Lean (see below). **This is a major finding**: the Lean uses the same name as the
  blueprint's declaration but proves a strictly weaker statement.

---

### `gf_common_basicOpen_basis` (helper — **unblueprinted**, new in iter-054)

- **Lean target exists**: yes (line 2895)
- **Blueprint reference**: NONE — no `\lean{...}` reference in any blueprint block
- **Proof status**: **sorry** (3 goals remain; `refine ⟨g, ?_, hg_mem, hg_le_O, ?_, ?_⟩ <;> sorry`)
- **notes**:

  This is a new helper introduced in iter-054, feeding B2.4. It is not referenced by the
  blueprint. Its docstring contains an explicit NOTE (lines 2888–2892):

  > "the blueprint/B2.1 *restriction-matched* datum `g|_O = ḡ|_O` is **not constructible** in
  > general — the realisation above only yields `ḡ = (unit)·g` on the overlap, so the achievable
  > invariant is the basic-open equality `X.basicOpen g = X.basicOpen ḡ` (which is all B2.2/the
  > assembly consume; `D(g) = D(ḡ)` makes `Γ(F, D(g))` one group). The conclusion here is
  > therefore stated as the basic-open equality, not the restriction equality."

  **Invariant mismatch (CONFIRMED — directive question).**
  The blueprint's `lem:gf_crossChart_spanning_cover` proof sketch says the spanning family
  comes with a "matched pair `g_k, ḡ_k` that agree over the overlap `W ⊓ Wⱼ`" — i.e., carries
  the stronger invariant `g|_O = ḡ|_O`. The Lean's helper can only produce the weaker invariant
  `D(g) = D(ḡ)` (basic-open equality), because the cross-chart realisation `g|_{D(b)} = ḡ'/bⁿ`
  only makes `D(b · ḡ') = D(g)` via `basicOpen_mul`, not `g|_O = ḡ|_O`.

  **Assessment:** The weaker invariant is mathematically sufficient for the downstream use —
  `D(g) = D(ḡ)` is all that is needed to identify `Γ(F, D(g))` with `Γ(F, D(ḡ))`, which is
  what B2.2 needs. The blueprint's stronger invariant is an over-specification. However, the
  helper body is incomplete (sorry), so B2.4 is blocked.

---

### `\lean{AlgebraicGeometry.gf_crossChart_spanning_cover}` (lem:gf_crossChart_spanning_cover, B2.4)

- **Lean target exists**: yes (line 2923)
- **Signature matches**: **partial** — invariant weakened from blueprint
- **Proof follows sketch**: partial (own body is axiom-clean, but delegates to `gf_common_basicOpen_basis` which has sorry)
- **Axiom status**: **effectively has sorry** (via `gf_common_basicOpen_basis`)
- **notes**:

  The Lean conclusion:
  ```lean
  ∃ (t : Finset Γ(X, W)), Ideal.span (t : Set Γ(X, W)) = ⊤ ∧
    ∀ g ∈ t, ∃ (i : ι) (gbar : Γ(X, Wj i)),
      X.basicOpen g ≤ W ⊓ Wj i ∧ X.basicOpen gbar ≤ W ⊓ Wj i ∧
      X.basicOpen g = X.basicOpen gbar
  ```
  The blueprint's conclusion has the additional invariant that each `gbar` "agrees with `g`
  over the overlap" (restriction-matched). The Lean only guarantees `D(g) = D(ḡ)`.

  This weakening is documented and intentional (same NOTE as for `gf_common_basicOpen_basis`).
  The downstream consumer needs only the basic-open equality, not the restriction-match.

  The body of B2.4 itself is logically correct given a complete `gf_common_basicOpen_basis`,
  but that helper has 3 sorry goals remaining, making B2.4 effectively incomplete.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (thm:generic_flatness)

- **Lean target exists**: yes (line 2967)
- **Signature matches**: yes — `[IsIntegral S] [IsLocallyNoetherian S]`,
  `(p : X ⟶ S) [LocallyOfFiniteType p] [QuasiCompact p]`,
  `[F.IsQuasicoherent] [F.IsFiniteType]`. The `[QuasiCompact p]` addition versus the
  blueprint's "finite type" is justified in the Lean comment with a detailed counterexample
  (lines 3001–3013) and is mathematically correct.
- **Proof follows sketch**: N/A — body is `:= sorry`
- **Axiom status**: **placeholder** (sorry)
- **notes**:

  The Lean comment at lines 3039–3056 documents the remaining gaps:
  - B2.4's helper `gf_common_basicOpen_basis` (sorry)
  - `gf_flat_locality_assembly` is entirely missing
  - The cover/algebraic scaffold (steps A and B in the comment)

  The sorry is expected given the documented missing pieces, not a hidden or unexplained
  placeholder.

---

## Red flags

### Placeholder / suspect bodies
- `gf_common_basicOpen_basis` at line 2912: `refine ⟨g, ?_, hg_mem, hg_le_O, ?_, ?_⟩ <;> sorry` — 3 goals remain. This is an unblueprinted helper, but B2.4 (`gf_crossChart_spanning_cover`) depends on it, making B2.4 indirectly incomplete.
- `genericFlatness` at line 3057: `:= sorry`. Blueprint claims a substantive proof sketch (Nitsure §4 geometric form). Expected pending missing pieces.

---

## Unreferenced declarations (informational)

The following project-bespoke declarations appear in the Lean file with no corresponding `\lean{...}` reference in the blueprint. Those whose names suggest blueprint-level significance are flagged:

**Flagged (substantive, should have blueprint coverage):**
- `gf_common_basicOpen_basis` (line 2895) — new iter-054 helper with sorry; the blueprint should document this as a named sub-lemma (it is the genuine geometric crux for B2.4).

**Unreferenced helpers (expected, acceptable):**
- `isLocalization_lift_injective` (line 473) — actually IS referenced by the blueprint (lem:gf_isLocalization_lift_injective). No issue.
- Most internal helpers in the Nagata/devissage section are acceptable helpers.

**Private declarations with blueprint `\lean{...}` references (11 items):**
The following declarations are all marked `private` in the Lean but are referenced by name in the blueprint's `\lean{...}` hints:
`T1`, `t1_comp_t1_neg`, `T`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`,
`leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`,
`finSuccEquiv_rename_succ`.

Being `private`, these cannot be looked up by `sync_leanok` / `lean_verify` by name. The
blueprint's `\leanok` markers for their blocks may not reflect actual sorry status. This is a
minor cross-cutting issue, not a correctness problem.

---

## Three missing blueprinted declarations

The following declarations are referenced by `\lean{...}` in the blueprint but **do not exist** in the Lean file:

### `\lean{AlgebraicGeometry.gf_stalk_flat_over_base}` (lem:gf_stalk_flat_over_base, G3.2)

Blueprint reference: line 1883 of the `.tex` file. Lean file contains no matching declaration.

The file comment at lines 2706–2712 explains:
> "the fourth (G3.2, `lem:gf_stalk_flat_over_base`) and the assembly itself are stated in the
> blueprint over *stalks* `F_x` of the sheaf of modules, an abstraction that Mathlib's
> `SheafOfModules` API does **not** yet provide (there is no `SheafOfModules.stalk` /
> `Scheme.Modules.stalk`)."

The Lean has replaced G3.2's role with an alternative algebraic approach (source-span descent
rather than stalkwise flatness). This is a route change, not an omission.

### `\lean{AlgebraicGeometry.gf_section_localization_flat_descent}` (lem:gf_section_localization_flat_descent, B2 assembly)

Blueprint reference: line 2116. This is the blueprint's bundled assembly of B2.1 + B2.2 + B2.3
into a single reusable statement consumed by `gf_flat_locality_assembly`. Not present in Lean —
the components (B2.1–B2.4) exist individually but the assembly declaration is absent.

### `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` (lem:gf_flat_locality_assembly, G3)

Blueprint reference: line 2188. The flat-locality assembly is the key G3 lemma that connects
per-patch freeness to sheaf-level flatness. **Not present in the Lean file.** Lean comment at
line 3048 lists this as item (A) of the remaining work for `genericFlatness`.

---

## Blueprint adequacy for this file

- **Coverage**: Approximately 67/70 project-bespoke Lean declarations have a corresponding `\lean{...}` block in the blueprint. Missing from blueprint: `gf_common_basicOpen_basis` (new helper, should be added). Three blueprint-referenced declarations are absent from Lean (G3.2, B2 assembly, G3).
- **Proof-sketch depth**: **adequate** for completed parts. The blueprint's proof sketches for B2.1–B2.4 are detailed and guided the formalization faithfully, with the documented exception that the restriction-matching invariant (`g|_O = ḡ|_O`) is stated in the blueprint but weaker basic-open equality (`D(g) = D(ḡ)`) is what the Lean produces. The B2 and G3 sketches need updating to reflect actual Lean invariants.
- **Hint precision**: **partially loose** — B2.3's `\lean{...}` hint names a declaration that exists but proves a different (weaker) type than the blueprint prose. Blueprint says IsLocalization; Lean proves Module.Flat.
- **Generality**: matches need for completed parts.
- **Recommended chapter-side actions**:
  1. Add a `\lean{AlgebraicGeometry.gf_common_basicOpen_basis}` block for the new helper, with proof sketch covering the `IsLocalization.surj`-based cross-chart construction and NOTE that `g|_O = ḡ|_O` is not achievable.
  2. Update `lem:gf_crossChart_spanning_cover` proof to state the invariant is basic-open equality `D(g_k) = D(ḡ_k)`, not restriction-matching `g_k|_O = ḡ_k|_O`.
  3. Update `lem:gf_section_localization_twoleg` to reflect that the Lean statement is proved for both legs independently (no D(g) = D(ḡ) input needed), with the matching supplied by the caller.
  4. Correct `lem:gf_base_localization_comparison` prose: the Lean proves `Module.Flat`, not `IsLocalization`. Either strengthen the Lean or downgrade the blueprint's claim and note that flatness suffices.
  5. Either add `lem:gf_stalk_flat_over_base` as a conceptual-only block (with note that `SheafOfModules.stalk` is unavailable and the route uses source-span descent instead), or remove the `\lean{...}` reference.
  6. Either add `lem:gf_section_localization_flat_descent` to the Lean (assembling B2.1–B2.3) or remove the blueprint block and fold its content into `lem:gf_flat_locality_assembly`.

---

## Severity summary

| Finding | Item | Severity |
|---------|------|----------|
| Placeholder sorry body | `gf_common_basicOpen_basis` (line 2912) — unblueprinted helper blocking B2.4 | **must-fix-this-iter** |
| Placeholder sorry body | `genericFlatness` (line 3057) — expected given documented gaps | **must-fix-this-iter** |
| Signature mismatch | `gf_base_localization_comparison` (B2.3): Lean proves `Module.Flat`, blueprint claims `IsLocalization` | **major** |
| Missing declaration | `gf_section_localization_flat_descent` (B2 assembly) — blueprinted, absent from Lean | **major** |
| Missing declaration | `gf_flat_locality_assembly` (G3) — blueprinted, absent from Lean | **major** |
| Missing declaration | `gf_stalk_flat_over_base` (G3.2) — blueprinted, absent from Lean (route change documented) | **major** |
| Invariant weakening | B2.2 (`gf_section_localization_twoleg`): Lean omits matched-restriction precondition | **minor** (intentional, documented, downstream-safe) |
| Invariant weakening | B2.4 (`gf_crossChart_spanning_cover`) / `gf_common_basicOpen_basis`: produces `D(g) = D(ḡ)` not `g|_O = ḡ|_O` | **minor** (intentional, documented, downstream-safe) |
| Missing blueprint block | `gf_common_basicOpen_basis` not referenced by blueprint at all | **major** (substantive helper needs blueprint documentation) |
| Private declarations | 11 Nagata/devissage helpers marked `private` but referenced by `\lean{...}` | **minor** |
| Blueprint adequacy | B2.3 blueprint prose claims IsLocalization; chapter needs correction | **major** |

**Overall verdict**: The B2 chain is present and largely sound, but has two must-fix blockers
(`gf_common_basicOpen_basis` sorry propagating to B2.4 and `genericFlatness` sorry), plus three
major gaps (B2 assembly and G3/G3.2 absent from Lean), and one major type mismatch in B2.3.
The key prover-reported invariant finding is confirmed: the blueprint's restriction-matched pair
`g|_O = ḡ|_O` invariant for B2.2/B2.4 is NOT what the Lean proves; the Lean uses basic-open
equality `D(g) = D(ḡ)`, which is weaker but sufficient and intentionally documented.

Total `\lean{...}`-referenced declarations checked: ~70. Red flags: 5 (2 placeholder sorrys,
3 missing declarations).
