# Lean ↔ Blueprint Check Report

## Slug
h1v

## Iteration
196

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.IsFlasque}` (chapter: `def:isFlasque_sheaf`)
- **Lean target exists**: yes (L98–102)
- **Signature matches**: yes — predicate on `Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)`, asserts `Function.Surjective` on every restriction map `(F.val.map (homOfLE h).op).hom`, matching the blueprint's "surjectivity of every restriction map" description exactly.
- **Proof follows sketch**: N/A (definition, not a proof)
- **notes**: Axiom-clean. Blueprint `\leanok` on statement block: accurate.

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.pushforward}` (chapter: `lem:isFlasque_pushforward`)
- **Lean target exists**: yes (L118–125)
- **Signature matches**: yes — `f : X ⟶ Y`, `hF : Scheme.IsFlasque F` → `Scheme.IsFlasque ((pushforward _ f).obj F)`.
- **Proof follows sketch**: yes — one-liner `hF ((Opens.map f).map (homOfLE h)).le`, exactly the "restriction of pushforward = restriction on preimages" argument of the blueprint.
- **notes**: Axiom-clean. Blueprint `\leanok` on both statement and proof blocks: accurate.

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.constant_of_irreducible}` (chapter: `lem:isFlasque_constant_irreducible`)
- **Lean target exists**: yes (L138–178)
- **Signature matches**: yes — `[IrreducibleSpace X]`, `A : ModuleCat.{u} kbar` → `Scheme.IsFlasque ((constantSheaf J _).obj A)`.
- **Proof follows sketch**: **partial**. The empty-open branch is closed axiom-clean (L156–176) via `TopCat.Sheaf.isTerminalOfEqEmpty` → `IsTerminal.isZero` → `ModuleCat.subsingleton_of_isZero`. The non-empty branch (L177–178) is a bare `sorry`.
- **notes**:
  - The blueprint proof sketch (lines 173–181) states "for every inclusion of non-empty opens V ⊆ U, the restriction map is the identity on A — in particular surjective" without acknowledging that in Lean this requires the `constantSheaf` sheafification-unit-iso on irreducible spaces, which Mathlib snapshot `b80f227` does not ship. The Lean comment (L150–154) is explicit about this Mathlib gap; the blueprint is not.
  - Blueprint `\leanok` on statement block (L155): accurate (typed sorry exists with correct signature). Blueprint proof block has **no** `\leanok`: accurate (proof not closed). Markers are consistent.
  - **This sorry is the iter-196 focus area**: the empty branch is now closed but the non-empty branch remains open pending a Mathlib lemma.

---

### `\lean{AlgebraicGeometry.Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque}` (chapter: `lem:flasque_cokernel_short_exact`)
- **Lean target exists**: yes (L578–595)
- **Signature matches**: yes — takes `hI : Scheme.IsFlasque S.X₂` and `h_b : ∀ U, Function.Surjective (...)` (the Ex. 1.16(b) input packaged as a parameter, exactly as the blueprint describes).
- **Proof follows sketch**: yes — lift via `h_b V`, extend via flasqueness at `hI hVU`, apply `S.g` at `U`, close via `naturality_apply`. Matches the 4-step blueprint argument verbatim.
- **notes**: Axiom-clean. Blueprint `\leanok` on statement block only (no separate proof block): consistent.

---

### `\lean{AlgebraicGeometry.ext_succ_eq_zero_of_injective_of_lower_zero}` (chapter: `lem:ext_succ_zero_of_injective_lower_zero`)
- **Lean target exists**: yes (L307–321)
- **Signature matches**: yes — `[Injective S.X₂]`, `n₀ ≥ 1`, `∀ y : Ext X S.X₃ n₀, y = 0` → `x₁ : Ext X S.X₁ (n₀+1) → x₁ = 0`. Matches blueprint statement exactly.
- **Proof follows sketch**: yes — `HasInjectiveDimensionLT.subsingleton` → `covariant_sequence_exact₁` → zero source → `zero_comp`. Matches the degree-shifting argument in the blueprint.
- **notes**: Axiom-clean. Blueprint `\leanok` on statement block only: consistent.

---

### `\lean{AlgebraicGeometry.Scheme.HModule_flasque_eq_zero}` (chapter: `thm:H1_vanishing_flasque`)
- **Lean target exists**: yes (L768–778)
- **Signature matches**: yes — `hF : Scheme.IsFlasque F`, `i : ℕ`, `hi : 1 ≤ i` → `Module.finrank kbar (HModule kbar F i) = 0`.
- **Proof follows sketch**: yes — strong induction via `HModule_flasque_subsingleton_aux` (private auxiliary, L632), which mirrors Hartshorne's induction exactly: `i=1` via `ext_one_eq_zero_of_hom_surjective_of_injective` + `constantSheafAdj`; `i≥2` via `ext_succ_eq_zero_of_injective_of_lower_zero` + flasque quotient inheritance.
- **notes**:
  - **Transitive sorry concern**: `HModule_flasque_eq_zero` has no direct sorry, but it calls the private `HModule_flasque_subsingleton_aux` which calls `Scheme.IsFlasque.injective_flasque` (L613–618, full `sorry` body). The proof is structurally closed but NOT sorry-free in the mathematical sense.
  - Blueprint `\leanok` on **both** statement (L277) and proof (L316) blocks. The proof `\leanok` reflects that `HModule_flasque_eq_zero`'s own body contains no sorry token, but this is misleading because the proof cannot be completed without resolving `injective_flasque`. If `sync_leanok` counts only direct sorries in the pinned declaration, the marker is technically correct by project convention but mathematically overstates closure.
  - The blueprint proof text mentions "The injective object I is flasque by the Hartshorne III Lemma 2.4 input" but does not reference a `\lean{...}` pin for `injective_flasque`. See **Unreferenced declarations** below.

---

### `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_eq_pushforward_const}` (chapter: `lem:skyscraperSheaf_eq_pushforward`)
- **Lean target exists**: yes (L818–862)
- **Signature matches**: **partial** — Blueprint claims "naturally isomorphic to the pushforward ... of the constant sheaf"; Lean statement type is `Nonempty (skyscraperSheaf P A ≅ (pushforward _).obj ((constantSheaf _).obj A))`. The `Nonempty` wrapper is a deliberate weakening: the blueprint does not authorize `Nonempty`, it claims a concrete isomorphism.
- **Proof follows sketch**: **partial**. The outer equality step (Step 1, L835–843) is closed axiom-clean via `ObjectProperty.FullSubcategory.ext` + `skyscraperPresheaf_eq_pushforward`. The inner iso (Step 2, L851–855), `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A`, carries a bare `sorry` (L855).
- **notes**:
  - The sorry is documented as a blocking gap for iter-197+ pickup (L849 comment). The `Nonempty` wrapping is a consequence of using `Classical.choice` to unpack the inner iso (L858).
  - **Signature mismatch**: `Nonempty (iso)` vs `iso` is a materially weaker statement. Downstream consumers that extract actual iso morphisms will not be satisfiable from this declaration.
  - Blueprint `\leanok` on statement block (L400): accurate (typed sorry present with correct signature at the `Nonempty` level). Blueprint proof block (L423–437) has **no** `\leanok`: accurate. Markers are consistent.
  - Blueprint proof sketch (L424–437) describes a pointwise argument ("both presheaves send U to A when P ∈ U, to 0 when P ∉ U") that applies at the presheaf level but does not discuss the inner iso (skyscraperSheaf on PUnit ≅ constantSheaf on PUnit) which is the actual blocking technical step in the Lean proof. The sketch is under-specified.

---

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.closure_isIrreducible}` (chapter: `lem:closedPoint_closure_irreducible`)
- **Lean target exists**: yes (L876–879)
- **Signature matches**: yes — `P : X.PrimeDivisor` → `IsIrreducible (closure {P.point})`.
- **Proof follows sketch**: yes — `isIrreducible_singleton.closure`, matching the "singleton is irreducible, closure preserves irreducibility" argument.
- **notes**: Axiom-clean. Blueprint `\leanok` on both statement (L441) and proof (L458): accurate.

---

### `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_isFlasque}` (chapter: `lem:skyscraperSheaf_isFlasque`)
- **Lean target exists**: yes (L903–939)
- **Signature matches**: yes — full curve hypothesis package, `P : C.left.PrimeDivisor` → `Scheme.IsFlasque (skyscraperSheaf P.point (ModuleCat.of kbar kbar))`.
- **Proof follows sketch**: **partial** — the blueprint proof (L492–505) instructs using the four-lemma chain: `skyscraperSheaf_eq_pushforward_const` → `PrimeDivisor.closure_isIrreducible` → `IsFlasque.constant_of_irreducible` → `IsFlasque.pushforward`. The Lean proof (L913–939) bypasses all four: it unfolds `skyscraperPresheaf`, dispatches `P.point ∈ V` (restriction = `eqToHom`, hence iso, hence surjective) vs `P.point ∉ V` (codomain is terminal/zero, hence `Subsingleton`). The mathematical conclusion is the same; the proof strategy is entirely different.
- **notes**:
  - The Lean docstring (L892–898) explicitly acknowledges this route divergence.
  - **Consequence**: The blueprint's `\uses{..., lem:skyscraperSheaf_eq_pushforward, lem:isFlasque_constant_irreducible, ...}` for this lemma are **stale dependencies** — the Lean proof does not use these lemmas. In particular, `skyscraperSheaf_eq_pushforward_const` (which has a sorry and a weakened `Nonempty` type) is listed as a dependency but is not consumed by the proof.
  - Blueprint `\leanok` on both statement (L468) and proof (L492): accurate — the Lean proof is axiom-clean (no sorries, no transitive sorry dependency through this proof path).

---

### `\lean{AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero}` (chapter: `lem:H1_skyscraperSheaf_finrank_eq_zero_main`)
- **Lean target exists**: yes (L965–976)
- **Signature matches**: yes — full curve hypothesis package, `P : C.left.PrimeDivisor` → `Module.finrank kbar (HModule kbar (skyscraperSheaf P.point (ModuleCat.of kbar kbar)) 1) = 0`.
- **Proof follows sketch**: yes — `HModule_flasque_eq_zero (skyscraperSheaf_isFlasque C P) 1 le_rfl`, exactly the blueprint's "compose `skyscraperSheaf_isFlasque` and `HModule_flasque_eq_zero` at i=1" strategy.
- **notes**:
  - Blueprint `\leanok` on both statement (L513) and proof (L539): accurate for the `sync_leanok` convention (no direct sorry in body). Same transitive sorry caveat as `HModule_flasque_eq_zero` applies here via the `injective_flasque` chain.
  - The Lean note at L957–960 acknowledges that the `private` copy in `RRFormula.lean` is a separate entity; this public declaration is the one the blueprint pin resolves. This is consistent and correct.

---

## Red Flags

### Placeholder / suspect bodies

- **`Scheme.IsFlasque.constant_of_irreducible`, L178**: `sorry` in the non-empty branch of the proof. Blueprint proof sketch claims this branch follows because "the restriction map is the identity on A — in particular surjective", presenting it as trivial. The Lean comment (L150–154) explains it requires the sheafification-unit-iso on irreducible spaces, a known Mathlib gap. The sorry is on a substantive proof step that the blueprint presents as closed.

- **`Scheme.IsFlasque.injective_flasque`, L613–618**: Full `sorry` body (`:= by sorry`). This declaration is a structural substrate for `HModule_flasque_eq_zero` via the private auxiliary chain. The blueprint prose for `thm:H1_vanishing_flasque` references it ("The injective object I is flasque by the Hartshorne III Lemma 2.4 input") but assigns no `\lean{...}` pin. This declaration has ~100–150 LOC complexity estimated in the comment and is explicitly noted as "out-of-scope" per the iter-196 PROGRESS directive. As a result, `HModule_flasque_eq_zero` and `H1_skyscraperSheaf_finrank_eq_zero` are not fully proved despite carrying proof `\leanok` markers.

- **`Scheme.skyscraperSheaf_eq_pushforward_const`, L855**: `sorry` on the inner iso `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A`. Blueprint presents the full isomorphism as provable. The Lean wraps the overall statement in `Nonempty (iso)`, which is a signature weakening the blueprint does not authorize. The outer equality step is axiom-clean.

### Excuse-comments

- **L849 in `skyscraperSheaf_eq_pushforward_const`**: "Documented blocking gap for iter-197+ pickup." This is a forward-scheduling note, not a misleading excuse. Flagged informational only.

### Axioms / Classical.choice on non-trivial claims

- **L858 in `skyscraperSheaf_eq_pushforward_const`**: `Classical.choice hinner_iso` is used to extract the inner iso from the `Nonempty` wrapper, then composed with the outer `eqToIso`. Because `hinner_iso` is obtained from a `sorry`, this `Classical.choice` operates on a `sorry`-backed value. Not a new axiom introduction, but a `Classical.choice` on a sorry-derived term.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` pin in the blueprint:

| Declaration | Line | Notes |
|---|---|---|
| `Scheme.HModule_injective_finrank_eq_zero` | L198 | Used in `HModule_flasque_subsingleton_aux` as the "injective ⇒ Ext vanishes" input. Substantive; worth a `\lean{...}` pin. |
| `Scheme.injectiveSES` | L215 | Non-computable def constructing the canonical injective SES. Helper. |
| `Scheme.injectiveSES_shortExact` | L226 | Proof that the above is short exact. Helper but substantive. |
| `ext_one_eq_zero_of_hom_surjective_of_injective` | L258 | Key lemma for the i=1 case in `HModule_flasque_subsingleton_aux`. Substantive: 30+ LOC, named, axiom-clean. Blueprint proof of `thm:H1_vanishing_flasque` references the i=1 argument but has no `\lean{...}` for this helper. |
| `sheafCompose_additive` | L348 | Instance. Infrastructure helper. |
| `sheafCompose_preservesZero` | L366 | Instance. Infrastructure helper. |
| `sheafCompose_preservesFiniteLimits` | L390 | Instance. Infrastructure helper. |
| `Scheme.IsFlasque.toAddCommGrpCat` | L422 | Converts `Scheme.IsFlasque` to `TopCat.Sheaf.IsFlasque` via `forget₂`. Substantive bridge lemma. |
| `Scheme.IsFlasque.shortExact_app_surjective` | L477 | Hartshorne II.1 Ex. 1.16(b): flasque + SES ⇒ sections-surjective. Large (~75 LOC), axiom-clean. Blueprint prose references the argument but no `\lean{...}` pin. |
| **`Scheme.IsFlasque.injective_flasque`** | L613 | **Full `sorry` body. Substantive (Hartshorne III Lemma 2.4). Blueprint prose references it in the proof of `thm:H1_vanishing_flasque` but no `\lean{...}` pin. Transitively blocks `HModule_flasque_eq_zero` and the headline result.** |
| `Scheme.HModule_flasque_subsingleton_aux` | L632 | Private auxiliary. Helper. |

The most significant unreferenced declaration is `Scheme.IsFlasque.injective_flasque`: it is the sole remaining sorry that prevents `HModule_flasque_eq_zero` from being genuinely closed, yet it carries no `\lean{...}` pin and therefore no blueprint-managed closure target.

---

## Blueprint adequacy for this file

- **Coverage**: 10/10 `\lean{...}`-pinned declarations exist in the Lean file. 11 additional helper declarations exist with no pin; of these, 2–3 are substantive enough to warrant pins (see table above, especially `injective_flasque`, `ext_one_eq_zero_of_hom_surjective_of_injective`, `shortExact_app_surjective`).

- **Proof-sketch depth**: **under-specified** at two locations:
  1. `lem:isFlasque_constant_irreducible` (proof, L171–182): the non-empty branch is described as "restriction map is the identity on A" without acknowledging the `constantSheaf` sheafification-unit-iso requirement that is the actual blocking Lean step. A prover reading the blueprint would not know a Mathlib lemma is missing here.
  2. `lem:skyscraperSheaf_eq_pushforward` (proof, L424–437): the argument is described at the presheaf level without acknowledging the inner iso (`skyscraperSheaf PUnit.unit A ≅ constantSheaf on PUnit`) that is the blocking technical step in Lean. The `Nonempty` weakening in the Lean signature is also unmentioned.

- **Hint precision**: **loose** at one location:
  - `lem:skyscraperSheaf_eq_pushforward` `\lean{...}` pins `skyscraperSheaf_eq_pushforward_const`, whose return type is `Nonempty (iso)` rather than `iso`. The blueprint prose says "naturally isomorphic" without hinting that the Lean statement is weaker. Downstream consumers that want the actual iso morphisms will be blocked.

- **Dependency accuracy**: **inaccurate** for `lem:skyscraperSheaf_isFlasque`:
  - The blueprint's `\uses{..., lem:skyscraperSheaf_eq_pushforward, lem:isFlasque_constant_irreducible, lem:isFlasque_pushforward, ...}` lists four sub-lemmas. The Lean proof uses **none** of these: it goes directly via `skyscraperPresheaf_map` on both branches of the `P.point ∈ V` case split. This makes the blueprint dependency graph inaccurate (it falsely implies this lemma depends on the two sorry-carrying declarations).

- **Generality**: matches need — no generality mismatch observed.

- **Recommended chapter-side actions**:
  1. Add a `% NOTE:` to `lem:isFlasque_constant_irreducible`'s proof block acknowledging the Mathlib gap in the non-empty branch and the pending sheafification-unit-iso requirement.
  2. Add a `% NOTE:` to `lem:skyscraperSheaf_eq_pushforward`'s proof block describing the inner iso (`skyscraperSheaf PUnit.unit ≅ constantSheaf on PUnit`) as the blocking sub-step and noting the `Nonempty` weakening in the current Lean statement.
  3. Add a `\lean{AlgebraicGeometry.Scheme.IsFlasque.injective_flasque}` pin under `thm:H1_vanishing_flasque` (as a `\uses{}` substrate with its own statement block) so `sync_leanok` tracks closure of this key sorry independently from the headline theorem.
  4. Update `\uses{...}` for `lem:skyscraperSheaf_isFlasque` to remove the stale `lem:skyscraperSheaf_eq_pushforward` and `lem:isFlasque_constant_irreducible` dependencies (the Lean proof doesn't use them).
  5. Consider adding pins for `ext_one_eq_zero_of_hom_surjective_of_injective` and `shortExact_app_surjective` to bring the blueprint coverage of the `thm:H1_vanishing_flasque` substrate up to the actual Lean structure.

---

## Severity summary

| Finding | Declaration | Severity |
|---|---|---|
| Non-empty branch `sorry` on substantive proof step the blueprint presents as immediate | `constant_of_irreducible` (L178) | **must-fix-this-iter** |
| `Nonempty (iso)` signature weaker than blueprint's "naturally isomorphic" claim | `skyscraperSheaf_eq_pushforward_const` (L818) | **must-fix-this-iter** |
| Inner iso `sorry` on substantive step; blueprint proof sketch does not describe the blocking technical path | `skyscraperSheaf_eq_pushforward_const` (L855) | **must-fix-this-iter** |
| Full `sorry` body on a substantive carrier (`injective_flasque`) that transitively blocks `HModule_flasque_eq_zero`; no `\lean{...}` pin | `injective_flasque` (L613) — out-of-scope per iter-196 directive | *informational* (out-of-scope; recorded for tracking) |
| Proof `\leanok` markers on `thm:H1_vanishing_flasque` and `lem:H1_skyscraperSheaf_finrank_eq_zero_main` may overstate closure given transitive `injective_flasque` sorry; depends on whether `sync_leanok` tracks transitive sorries | `HModule_flasque_eq_zero` (L768), `H1_skyscraperSheaf_finrank_eq_zero` (L965) | **major** |
| Blueprint `\uses{...}` for `skyscraperSheaf_isFlasque` includes `skyscraperSheaf_eq_pushforward` and `constant_of_irreducible`, neither of which the Lean proof uses | `lem:skyscraperSheaf_isFlasque` blueprint block | **major** |
| Blueprint proof sketch for `constant_of_irreducible` non-empty branch does not mention Mathlib gap | `lem:isFlasque_constant_irreducible` blueprint block | **major** |
| Blueprint proof sketch for `skyscraperSheaf_eq_pushforward_const` does not describe the inner iso technical step | `lem:skyscraperSheaf_eq_pushforward` blueprint block | **major** |
| Lean proof of `skyscraperSheaf_isFlasque` takes a different (direct) route than the blueprint's four-lemma chain | `lem:skyscraperSheaf_isFlasque` | **minor** |
| `injective_flasque`, `ext_one_eq_zero_of_hom_surjective_of_injective`, `shortExact_app_surjective` are substantive declarations with no `\lean{...}` pin | unreferenced declarations | **minor** |

**Overall verdict**: Three must-fix findings — the `Nonempty` signature weakening and inner iso sorry on `skyscraperSheaf_eq_pushforward_const`, and the non-empty branch sorry on `constant_of_irreducible` — together with two major blueprint adequacy failures (stale `\uses` on `skyscraperSheaf_isFlasque`; proof sketches that don't describe the blocking Mathlib gaps). The headline declaration `H1_skyscraperSheaf_finrank_eq_zero` is structurally assembled correctly and its own body is sorry-free, but its mathematical completeness is contingent on resolving `injective_flasque` (which is out-of-scope this iter per the PROGRESS directive).
