# Lean ↔ Blueprint Check Report

## Slug
acyclic

## Iteration
005

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

---

## Per-declaration

### `\lean{CategoryTheory.InjectiveResolution.isoRightDerivedObj}` (`lem:right_derived_injective_resolution`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: correct.

### `\lean{CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ}` (`lem:right_derived_vanishes_injective`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: correct.

### `\lean{CategoryTheory.Functor.rightDerivedZeroIsoSelf}` (`lem:right_derived_zero_iso_self`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: correct.

### `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₁, ...homology_exact₂, ...homology_exact₃, ...δ}` (`lem:homology_long_exact_sequence`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: correct.

### `\lean{CategoryTheory.Functor.IsRightAcyclic}` (`def:right_acyclic`)
- **Lean target exists**: yes (`AcyclicResolution.lean:84`)
- **Signature matches**: yes — class field `vanish : ∀ k, IsZero ((G.rightDerived (k+1)).obj J)` matches blueprint's index-shifted quantifier exactly, with the remark on equivalent formulations acknowledged.
- **Proof follows sketch**: N/A (definition, no proof body)
- **notes**: `\leanok` on statement is correct.

### `\lean{CategoryTheory.Injective.instBiprod}` (`lem:horseshoe_biprod_injective`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: correct.

### `\lean{CategoryTheory.ShortComplex.Splitting.ofHasBinaryBiproduct}` (`lem:horseshoe_degree_split`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: correct.

### `\lean{CategoryTheory.mono_biprod_lift_factorThru_of_exact}` (`lem:horseshoe_stage_mono`)
- **Lean target exists**: yes (`AcyclicResolution.lean:181`)
- **Signature matches**: yes — `{S : ShortComplex 𝒜} (hS : S.Exact) [Mono S.f] {P Q : 𝒜} [Injective P] (α : S.X₁ ⟶ P) [Mono α] (γ : S.X₃ ⟶ Q) [Mono γ] : Mono (biprod.lift (Injective.factorThru α S.f) (S.g ≫ γ))` matches prose exactly.
- **Proof follows sketch**: yes — the proof in Lean follows the blueprint's sketch: compose with biproduct projections, cancel `γ`-mono, lift through `S.f` via exactness, kill via `α`-mono.
- **notes**: `\leanok` on statement and proof is correct.

---

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact_twist}` (`lem:horseshoe_twist`) — **STALE NAME**
- **Lean target exists**: **no** — no declaration named `InjectiveResolution.ofShortExact_twist` exists anywhere in the file.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: The mathematical content of `lem:horseshoe_twist` (the off-diagonal twist family + augmentation + cocycle identity) was realized by a cluster of declarations rather than one. The actual names:
  - `CategoryTheory.InjectiveResolution.horseshoeτ` (line 380) — the twist family `τⁿ : I_C^n → I_A^{n+1}`
  - `CategoryTheory.InjectiveResolution.horseshoeτ_cocycle` (line 384) — the cocycle identity `d_C^n ≫ τⁿ⁺¹ = -(τⁿ ≫ d_A^{n+1})`
  - `CategoryTheory.InjectiveResolution.twistPair` (line 359) — ℕ-recursion kernel (carries consecutive `τⁿ, τⁿ⁺¹` + cocycle witness)
  - `CategoryTheory.InjectiveResolution.horseshoeβ` (line 425) — the augmentation `β : B → I_A^0 ⊞ I_C^0`
  - `CategoryTheory.InjectiveResolution.horseshoeβ₁` (line 315) — first component `B → I_A^0` of β
  - `CategoryTheory.InjectiveResolution.horseshoeH` (line 323) — auxiliary map `C → I_A^1`
  - `CategoryTheory.InjectiveResolution.horseshoeτZero` (line 338) — base twist `I_C^0 → I_A^1`
  - `CategoryTheory.InjectiveResolution.ιC0` (line 416) — clean-domain augmentation `ses.X₃ → I_C^0`
  - Supporting simp lemmas: `f_comp_horseshoeβ₁`, `g_comp_horseshoeH`, `horseshoeH_comp_d`, `ιC_comp_horseshoeτZero`, `horseshoeτZero_hf`, `horseshoeβ_comp_d`, `ιC0_comp_d`, `ιC0_comp_τZero`, `horseshoeβ_fst`, `horseshoeβ_snd` (lines 319–451).
  The blueprint block is a single lemma; the Lean realization splits into 15+ named declarations. The `\lean{...}` hint must be replaced (see recommended actions).

---

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact_dComp}` (`lem:horseshoe_dComp`) — **STALE NAME**
- **Lean target exists**: **no** — no declaration `ofShortExact_dComp` in the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The mathematical content (the assembled matrix differential squares to zero) is realized by:
  - `CategoryTheory.twistedBiprodD_comp` (line 238) — proves `twistedBiprodD τ n ≫ twistedBiprodD τ (n+1) = 0` given the cocycle identity `hτ`.
  Note: this declaration lives in the top-level `TwistedBiprod` section (outside `InjectiveResolution`) because the prover correctly abstracted it injective-free. The blueprint block `lem:horseshoe_dComp` is framed inside the horseshoe narrative; the Lean abstraction layer is missing from the blueprint.

---

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact_chainMap}` (`lem:horseshoe_chainMap`) — **STALE NAME**
- **Lean target exists**: **no** — no declaration `ofShortExact_chainMap` in the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The mathematical content (coprojection/projection are chain maps, degreewise split) is realized by:
  - `CategoryTheory.twistedBiprodInl` (line 260) — the chain map `K → twistedBiprod`, degreewise `biprod.inl`
  - `CategoryTheory.twistedBiprodSnd` (line 268) — the chain map `twistedBiprod → L`, degreewise `biprod.snd`
  - `CategoryTheory.twistedBiprodSplitting` (line 286) — the degreewise biproduct splitting of `0 → K → twistedBiprod → L → 0`
  - `CategoryTheory.twistedBiprodInl_comp_Snd` (line 280) — composition is zero
  Again in the `TwistedBiprod` section, not under `InjectiveResolution`. The specialization to the horseshoe is `horseshoeSES` / `horseshoeSES_splitting` / `horseshoeSES_shortExact`.

---

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact_resolvesMiddle}` (`lem:horseshoe_resolvesMiddle`) — **ABSENT (remaining gap)**
- **Lean target exists**: **no** — no declaration of this name; no realization in the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Explicitly flagged in the file's status comment (lines 459–486) as the sole remaining gap. The Lean file has `horseshoeMid` (the complex) and `horseshoeβ_comp_d` (augmentation zero-composition), but the quasi-isomorphism / resolution claim `(single₀ B) ⟶ horseshoeMid` is a quasi-iso is NOT proven. As detailed below under "Blueprint adequacy," the blueprint's proof sketch for this lemma does not acknowledge the missing Mathlib tool (`quasiIso_τ₂`).

---

### `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` (`lem:injective_resolution_of_ses`) — **ABSENT (remaining gap)**
- **Lean target exists**: **no** — not present. The blueprint has `\leanok` on both statement and proof, which is incorrect.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: A `% NOTE (iter-004 review)` comment in the blueprint already documents the false `\leanok` markers and their cause (a backtick code-fence in the strategy comment of the Lean file that fooled `sync_leanok`). The structural components are present: `horseshoeMid`, `horseshoeSES`, `horseshoeSES_shortExact`, `horseshoeSES_splitting`. What's absent is the bundled `InjectiveResolution B` wrapping the middle complex with `resolvesMiddle`. The `\leanok` markers on statement and proof of `lem:injective_resolution_of_ses` are false-done and should be stripped (ownership: `sync_leanok` — but the NOTE comment already requests this fix).

---

### `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic}` (`lem:acyclic_dimension_shift`) — **ABSENT (pending, partially pre-built)**
- **Lean target exists**: **no** — no declaration of this name. However a related intermediate version `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (line 153) exists.
- **Signature matches**: partial — `rightDerivedShiftIsoOfSplitResolutionSES` takes explicit injective resolutions `I_A`, `I_J`, `I_Z` and explicit chain maps `φ`, `ψ` with degreewise splittings, rather than an object-level SES with an acyclic middle term. It is the "inner engine" of `rightDerivedShiftIsoOfAcyclic` but not the user-facing version. The Lean produces `(k+1, k+2)` indices; the blueprint states `(k, k+1)` for k ≥ 1 — an equivalent reindexing. Part (2) of the blueprint (base case: `(R¹G)(A) ≅ coker(G(J)→G(Z))`) is NOT realized in `rightDerivedShiftIsoOfSplitResolutionSES`.
- **Proof follows sketch**: yes (partially) — `rightDerivedShiftIsoOfSplitResolutionSES` uses `δIso` with the vanishing hypotheses from `isZero_homology_mapHomologicalComplex_of_isRightAcyclic`, which implements the "killing acyclic terms" step. The object-level version remains pending because it requires `ofShortExact`.
- **notes**: Not stale — the name `rightDerivedShiftIsoOfAcyclic` is the intended target. The `\lean{...}` hint is forward-pointing (correct target name), not wrong. The companion `rightDerivedShiftIsoOfSplitResolutionSES` should get its own `\lean{...}` reference in a new or expanded blueprint block.

---

### `\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}` (`lem:acyclic_resolution_computes_derived`) — **ABSENT (remaining target)**
- **Lean target exists**: **no** — not present; no realization in the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Not stale — correct target name for a future declaration. Blocked by `ofShortExact` and `rightDerivedShiftIsoOfAcyclic`.

---

## Red flags

### Stale `\lean{...}` names (realized under different names)

| Blueprint block | Stale `\lean{...}` name | Actual Lean declaration(s) |
|---|---|---|
| `lem:horseshoe_twist` | `InjectiveResolution.ofShortExact_twist` | `InjectiveResolution.horseshoeτ`, `horseshoeτ_cocycle`, `twistPair`, `horseshoeβ`, `horseshoeβ₁`, `horseshoeH`, `horseshoeτZero` |
| `lem:horseshoe_dComp` | `InjectiveResolution.ofShortExact_dComp` | `twistedBiprodD_comp` (in `TwistedBiprod` section, not `InjectiveResolution` namespace) |
| `lem:horseshoe_chainMap` | `InjectiveResolution.ofShortExact_chainMap` | `twistedBiprodInl`, `twistedBiprodSnd`, `twistedBiprodSplitting` (+ `horseshoeSES*` specializations) |

All three stale hints point to `InjectiveResolution.ofShortExact_*` names that suggest a monolithic structure within the `InjectiveResolution` namespace, while the prover correctly extracted the injective-free `TwistedBiprod` abstraction and placed it at the `CategoryTheory` top level.

### False `\leanok` markers

- `lem:injective_resolution_of_ses` statement (blueprint line ~409): `\leanok` present but `InjectiveResolution.ofShortExact` does **not** exist. Already documented by the `% NOTE (iter-004 review)` comment in the blueprint; `sync_leanok` should strip it once the code-fence false-match is resolved.
- `lem:injective_resolution_of_ses` proof (blueprint line ~451): same.

These are not actionable by the review agent (owned by `sync_leanok`) but are documented here for completeness.

### No placeholder bodies or axioms

The file compiles with 0 sorries. No `:= sorry`, `:= True`, `:= Classical.choice _`, or `axiom` declarations found. No excuse-comments of the "wrong but works for now" kind.

---

## Unreferenced declarations (informational)

The following substantive declarations have no `\lean{...}` reference in the blueprint:

- `Functor.IsRightAcyclic.ofInjective` (line 89) — the instance that every injective is acyclic. Covered conceptually by `lem:right_derived_vanishes_injective` prose; no separate block needed but could get one.
- `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` (line 108) — homology-level form of acyclicity used by `rightDerivedShiftIsoOfSplitResolutionSES`. Blueprint has no block for this infrastructure lemma.
- `shortExact_of_degreewise_splitting` (line 121) — packages degreewise-split ⇒ short exact. No blueprint block.
- `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` (line 133) — `G` applied to degreewise-split ⇒ short exact. No blueprint block.
- `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (line 153) — the intermediate "inner engine" of `rightDerivedShiftIsoOfAcyclic`. Blueprint has no block for this; the `lem:acyclic_dimension_shift` block targets `rightDerivedShiftIsoOfAcyclic` (the future object-level version).
- `mono_biprod_lift_factorThru_of_exact` (line 181) — **IS** referenced, skip.
- **Entire `TwistedBiprod` section** (lines 197–293): `twistedBiprodD`, `twistedBiprod`, `twistedBiprodInl`, `twistedBiprodSnd`, `twistedBiprodSplitting` and their simp lemmas — 12+ declarations with no individual blueprint blocks. The blueprint covers the mathematical content of this section across `lem:horseshoe_dComp` and `lem:horseshoe_chainMap` (under the stale names), but does not describe this abstraction layer separately.
- **Augmentation helpers** in `InjectiveResolution.OfShortExact` section: `horseshoeβ₁`, `horseshoeH`, `horseshoeτZero`, `horseshoeτZero_hf`, `ιC0`, `ιC0_comp_d`, `ιC0_comp_τZero`, `horseshoeβ_fst`, `horseshoeβ_snd`, `horseshoeβ_comp_d`, `f_comp_horseshoeβ₁`, `g_comp_horseshoeH`, `horseshoeH_comp_d`, `ιC_comp_horseshoeτZero`, `horseshoeτ_zero`, `horseshoeMid`, `horseshoeSES`, `horseshoeSES_splitting`, `horseshoeSES_shortExact`, `twistPair`, `horseshoeτ`, `horseshoeτ_cocycle` — 22 declarations all absorbed into the three stale blueprint blocks.

The unreferenced count is large but almost all are helpers or intermediate structure declarations that fall under the umbrella of the stale-named blueprint blocks. The `TwistedBiprod` section is the only one that represents a genuine abstraction the blueprint doesn't describe at all.

---

## Blueprint adequacy for this file

### Coverage
- 2/43 Lean declarations have a direct `\lean{...}` blueprint block (plus 6 Mathlib-backed blocks): `IsRightAcyclic` and `mono_biprod_lift_factorThru_of_exact`.
- 3 blueprint blocks have stale `\lean{...}` names for already-realized content (items 1–3 above). The mathematical content is present in both documents but the names diverged.
- 4 blueprint blocks (`lem:horseshoe_resolvesMiddle`, `lem:injective_resolution_of_ses`, `lem:acyclic_dimension_shift`, `lem:acyclic_resolution_computes_derived`) target future declarations not yet in Lean — this is expected.
- Approximately 34 declarations are helpers/structure with no dedicated blueprint block — acceptable for helpers, but the `TwistedBiprod` section warrants its own block (see recommended actions).

### Proof-sketch depth
**Under-specified** for one key sub-lemma:

`lem:horseshoe_resolvesMiddle` — the blueprint proof says: "In the long exact sequence the terms flanking H^k(I_B) for k ≥ 1 vanish, forcing H^k(I_B) = 0; in degree 0 ... identifies H^0(I_B) ≅ B." This is a valid informal argument. However, **the blueprint does not acknowledge that the middle-term quasi-isomorphism transfer** (`quasiIso_τ₂`: "if two outer maps in a SES of complexes are quasi-isos, so is the middle one") **is ABSENT from Mathlib**. The Lean file's status comment (lines 478–486) makes clear this is the sole blocking gap and requires a custom construction (five-lemma on a 7-term LES window). The blueprint's proof sketch reads as routine when it is in fact the hardest remaining step. A `% NOTE:` annotation is needed.

The other pending lemmas (`lem:injective_resolution_of_ses`, `lem:acyclic_dimension_shift`, `lem:acyclic_resolution_computes_derived`) have adequate proof sketches for their eventual formalization once the sub-lemmas land.

`lem:horseshoe_twist` — the blueprint proof is adequate at the mathematical level (induction, use of injectivity to lift, cocycle derivation). The Lean realization is more verbose because of ℕ-recursion bookkeeping (`twistPair`) and helper maps (`horseshoeH`, `horseshoeβ₁`, `horseshoeτZero`), but the mathematical steps match the blueprint sketch.

`lem:horseshoe_dComp` and `lem:horseshoe_chainMap` — adequate at the mathematical level; the Lean `TwistedBiprod` abstraction layer is a generalization the blueprint doesn't mention but doesn't contradict.

### Hint precision
**Loose/wrong** for three blocks: the `\lean{...}` hints for `lem:horseshoe_twist`, `lem:horseshoe_dComp`, `lem:horseshoe_chainMap` all name declarations that do not exist and will not be created under those names. This will cause `sync_leanok` to permanently fail to detect completion of these blocks (LSP lookup returns "unknown constant"), even after all content is formalized. These are wrong hints.

**Adequate** for the remaining blocks (Mathlib blocks with `\mathlibok`, `IsRightAcyclic`, `mono_biprod_lift_factorThru_of_exact`, and the four future-goal blocks with correct target names).

### Generality
**Matches need / slightly too narrow** for the `TwistedBiprod` section: the blueprint describes the horseshoe complex only in the injective-resolution context, while the Lean correctly abstracts it to any pair of cochain complexes `K, L` with a cocycle family `τ`. The Lean is *more general* than the blueprint, which is fine — it means the abstraction layer can be used elsewhere. The blueprint doesn't need to match the Lean's generality but should at least describe the `twistedBiprod` construction so readers understand the design.

### Recommended chapter-side actions

1. **[major] Replace three stale `\lean{...}` hints** in the chapter:
   - `lem:horseshoe_twist`: replace `\lean{CategoryTheory.InjectiveResolution.ofShortExact_twist}` with a multi-target reference covering `CategoryTheory.InjectiveResolution.horseshoeτ`, `CategoryTheory.InjectiveResolution.horseshoeτ_cocycle`, `CategoryTheory.InjectiveResolution.horseshoeβ`, `CategoryTheory.InjectiveResolution.twistPair` (or split the block into sub-blocks per declaration).
   - `lem:horseshoe_dComp`: replace `\lean{CategoryTheory.InjectiveResolution.ofShortExact_dComp}` with `\lean{CategoryTheory.twistedBiprodD_comp}`.
   - `lem:horseshoe_chainMap`: replace `\lean{CategoryTheory.InjectiveResolution.ofShortExact_chainMap}` with `\lean{CategoryTheory.twistedBiprodInl, CategoryTheory.twistedBiprodSnd, CategoryTheory.twistedBiprodSplitting}` (and possibly `CategoryTheory.InjectiveResolution.horseshoeSES_shortExact`).

2. **[major] Add `% NOTE:` to `lem:horseshoe_resolvesMiddle`** acknowledging that formalizing the proof requires `quasiIso_τ₂` (middle-term quasi-iso transfer, absent from Mathlib) — not just the informal LES vanishing argument. This is the gate-blocking Lean gap.

3. **[minor] Add a `TwistedBiprod` blueprint block** (or subsection) describing the abstraction: given cochain complexes `K, L` and a cocycle family `τ : ∀ n, L.X n → K.X (n+1)` satisfying `d_L^n ≫ τ(n+1) = -(τ n ≫ d_K(n+1))`, the biproduct complex with matrix differential `[[d_K, τ], [0, d_L]]`. Reference `\lean{CategoryTheory.twistedBiprod}`, `\lean{CategoryTheory.twistedBiprodInl}`, `\lean{CategoryTheory.twistedBiprodSnd}`, `\lean{CategoryTheory.twistedBiprodSplitting}`.

4. **[minor] Add a blueprint block** for `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (the "inner engine" of the dimension shift, taking an explicit horseshoe SES) and reference `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES}`. This intermediate result is fully formalized and `\lean{...}`-unreferenced.

5. **[informational] False `\leanok` on `lem:injective_resolution_of_ses`**: already documented by the existing `% NOTE` comment; no additional action needed from a blueprint writer — `sync_leanok` will handle it once the code-fence false-match is fixed (see that NOTE).

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `\lean{...}` name `ofShortExact_twist` is stale; realized by `horseshoeτ`/`horseshoeτ_cocycle`/`twistPair`/`horseshoeβ`/etc. | **major** |
| 2 | `\lean{...}` name `ofShortExact_dComp` is stale; realized by `twistedBiprodD_comp` | **major** |
| 3 | `\lean{...}` name `ofShortExact_chainMap` is stale; realized by `twistedBiprodInl`/`twistedBiprodSnd`/`twistedBiprodSplitting` | **major** |
| 4 | `lem:horseshoe_resolvesMiddle` proof sketch does not acknowledge `quasiIso_τ₂` absence from Mathlib | **major** |
| 5 | `TwistedBiprod` abstraction section (12+ declarations) has no blueprint coverage | **minor** |
| 6 | `rightDerivedShiftIsoOfSplitResolutionSES` is fully formalized but has no `\lean{...}` blueprint block | **minor** |
| 7 | False `\leanok` on `lem:injective_resolution_of_ses` (already documented by NOTE; `sync_leanok` owns this) | **informational** |

**Overall verdict**: The Lean file is axiom-clean and fully compiles (0 sorries); all Lean code is mathematically faithful to the blueprint prose. The failures are entirely on the blueprint side: three `\lean{...}` hints point to non-existent names (content was realized under different names during this iter's prover work), the `lem:horseshoe_resolvesMiddle` proof sketch hand-waves the key Mathlib gap (`quasiIso_τ₂`), and the new `TwistedBiprod` abstraction layer is not described in the blueprint at all. No Lean code is wrong, no sorrys are present; the 4 major findings are blueprint corrections that `sync_leanok` will continue to misfire on until the stale `\lean{...}` names are corrected.
