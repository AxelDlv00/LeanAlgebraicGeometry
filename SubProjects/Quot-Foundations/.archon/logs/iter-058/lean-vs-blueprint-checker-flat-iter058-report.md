# Lean ↔ Blueprint Check Report

## Slug
flat-iter058

## Iteration
058

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (3590 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (2482 lines)

---

## Per-declaration (blueprint → Lean)

All `\lean{...}` pins that could be spot-checked were verified to resolve to existing declarations. A representative sample:

### `\lean{AlgebraicGeometry.genericFlatness}` (`thm:generic_flatness`)
- **Lean target exists**: yes (line 3251)
- **Signature matches**: yes — noetherian integral `S`, finite-type `p : X → S`, coherent `F`, witness open `V ≠ ∅` with `F|_{X_V}` flat over `𝒪_V`
- **Proof follows sketch**: partial — blueprint steps 1–4 are implemented. STEP 3 (`flatV` semilinearity close at line 3585) is a single `sorry`. See §Red flags.
- **Notes**: `\leanok` is on the *statement* block only (no proof-block `\leanok`), which is correct per project convention (statement formalized, proof not yet closed). One `sorry` remains.

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (`thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (line 1982)
- **Signature matches**: yes — noetherian domain `A`, finite-type algebra `B`, finite `B`-module `M`, produces `f ≠ 0` with `LocalizedModule (powers f) M` free over `Localization.Away f`
- **Proof follows sketch**: yes — the primary route (finite `A`-module leaf via `exists_free_localizationAway_of_finite`) and the full §4 dévissage (L1 torsion base, L3 splice, L4 Noether normalisation, L5 polynomial core + `free_localizationAway_of_away_tower`) are all assembled axiom-clean.
- **Notes**: Module docstring at line 1957 says "Surviving residue (`sorry` this iter)" — this is **stale**: the proof body (lines 1989–2142) contains no `sorry`. All L4/L5 machinery is now assembled and calls through to the closed declarations. See §Red flags.

### `\lean{AlgebraicGeometry.gf_flat_localizedModule_sameBase}` (`lem:gf_flat_localizedModule_sameBase`)
- **Lean target exists**: yes (line 2791)
- **Signature matches**: yes — `R → B → N` scalar tower, submonoid `T ⊆ B`, `N` flat over `R` ⟹ `LocalizedModule T N` flat over `R`
- **Proof follows sketch**: yes (axiom-clean)

### `\lean{AlgebraicGeometry.gf_crossChart_basicOpen_eq}` (`lem:gf_crossChart_basicOpen_eq`)
- **Lean target exists**: yes (line 2986)
- **Signature matches**: yes
- **Proof follows sketch**: yes (axiom-clean)

### `\lean{AlgebraicGeometry.gf_section_localization_twoleg}` (`lem:gf_section_localization_twoleg`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes (axiom-clean)

All other pinned declarations (`gf_finite_sections_of_basicOpen_finite_cover`, `gf_finiteType_affine_finite_cover_generated`, `gf_qcoh_fintype_finite_sections`, `gf_isEpi_restrict_of_affine_le`, `gf_flat_of_isEpi`, `gf_section_span_flat_descent`, `gf_crossChart_spanning_cover`, `module_finite_of_ringEquiv_semilinear`, all `GenericFreeness.*` lemmas) were spot-verified to exist in the Lean file with matching signatures. No stale or broken `\lean{}` pins were found.

---

## Red flags

### Stale excuse-comment

- **`FlatteningStratification.lean:1957`** — module-doc for `genericFlatnessAlgebraic` reads:
  ```
  * **Surviving residue** (`sorry` this iter): when `M` is finite over the
    *finite-type* algebra `B` ...
  ```
  The actual proof body at lines 1989–2142 is **completely sorry-free**: L4 (`exists_localizationAway_finite_mvPolynomial`) and L5 (`exists_free_localizationAway_polynomial`) are both invoked and close the proof. The "(sorry this iter)" annotation is a stale status comment from a prior iteration. It falsely claims the proof is incomplete.
  - **Severity**: **major** — stale but does not affect correctness; misleads future provers reading the module doc.

### Placeholder body

- **`FlatteningStratification.lean:3585`** — `sorry` inside the `flatV` sub-goal of `genericFlatness`. This is the sole `sorry` in the entire file.
  - Context: STEP 3 of the `flatV` block (lines 3563–3585) needs to transport `Module.Flat Γ(S, D f) Γ(F, X.basicOpen gbar')` to `Module.Flat Γ(S, D f) Γ(F, X.basicOpen g)` via the presheaf isomorphism `l` along `hbg : X.basicOpen gbar' = X.basicOpen g`. The blueprint's proof sketch for `thm:generic_flatness` does not spell out this semilinearity argument.
  - The Lean file's own comment (lines 3563–3584) gives a complete recipe: call `flat_of_ringEquiv_semilinear (RingEquiv.refl _) l ?_` where `l` is the presheaf map iso, then discharge semilinearity via `Scheme.Modules.map_smul` + the `map_appLE`/`appLE_map` commutative square (same algebra used in the `hsquare` proof above). All ingredients are confirmed to exist.
  - The `\leanok` on the statement block of `thm:generic_flatness` is correct (statement formalized, sorry present). The proof block `\leanok` is absent, which is also correct.
  - **Severity**: **major** — this `sorry` is in `genericFlatness`, not `genericFlatnessAlgebraic`. The blueprint marks the statement with `\leanok`, not the proof; this is consistent. However the sorry is in a substantive location of the file's key theorem.

---

## Unreferenced declarations (informational)

The following four declarations were added this iteration and have **no `\lean{...}` pin** in the blueprint. Three are substantive project-local lemmas that feed `genericFlatness` directly; one is a technical transport.

### `AlgebraicGeometry.gf_flat_isLocalizedModule_sameBase` (line 2810)
- **Blueprint coverage**: none
- **What it says**: B1′ — model-free variant of `gf_flat_localizedModule_sameBase`. Given any `IsLocalizedModule T φ` model `N'` of a source localization, if `N` is flat over `R` then `N'` is flat over `R`. This is the consumer-facing form actually called inside `genericFlatness` (to produce `hN'flat` at line 3559).
- **Relationship to blueprint**: `lem:gf_flat_localizedModule_sameBase` pins only the canonical-model form `LocalizedModule T N`. The B1′ variant is introduced to avoid the `LocalizedModule`-to-geometric-section-module bridge that would otherwise be needed inline; the blueprint prose alludes to this but does not name or pin the variant.

### `AlgebraicGeometry.flat_of_ringEquiv_semilinear` (line 2827)
- **Blueprint coverage**: none
- **What it says**: Flatness transfers across a ring isomorphism `e : R ≃+* R'` and a compatible additive isomorphism `l : M ≃+ M'` (semilinear: `l(r • x) = e(r) • l(x)`). Proof reduces to `Module.Flat.isBaseChange`.
- **Relationship to blueprint**: `lem:module_free_of_ringEquiv` (blueprint line 1063) pins the analogous *freeness* transfer `Module.Free.of_ringEquiv` as a Mathlib lemma. The flatness version is project-local and used by both `flat_localization_models` and the STEP-3 sorry close.

### `AlgebraicGeometry.flat_localization_models` (line 2886)
- **Blueprint coverage**: none
- **What it says**: If `Mₛ` and `Mₛ'` are two models of the `A`-module `M` localized at `S` (over respective localization rings `Rₛ`, `Rₛ'`), then `Mₛ` flat over `Rₛ` implies `Mₛ'` flat over `Rₛ'`. Proof: `IsLocalization.algEquiv` + `IsLocalizedModule.linearEquiv` are semilinear; `flat_of_ringEquiv_semilinear` applies.
- **Relationship to blueprint**: This is the bridge invoked at `genericFlatness` line 3526 to transfer canonical-model flatness (`LocalizedModule (powers f) Γ(F, Wi)` over `Localization.Away f`) to the geometric model (`Γ(F, Dfbar)` over `Γ(S, S.basicOpen f)`). The blueprint's STEP 4 prose mentions this bridge implicitly ("yields exactly `Γ(F, D(g))` flat over `A_f`") but does not name a lemma for the model-independence of flatness under localization.

### `AlgebraicGeometry.isLocalizedModule_powers_restrictScalars` (line 2928)
- **Blueprint coverage**: none
- **What it says**: If `φ : M →ₗ[B] N` exhibits `N` as the localization of `M` at `powers (algebraMap A B f)` (a submonoid of `B`), then `φ.restrictScalars A` exhibits `N` as the localization of `M` (as an `A`-module) at `powers f`. Technical descent of the `IsLocalizedModule` property along the scalar tower.
- **Relationship to blueprint**: Used at line 3497 to convert `hlocMif : IsLocalizedModule (powers fbar) ...` (over `Γ(X, Wi)`) into `hlocMifA : IsLocalizedModule (powers f) ... A` (over `A`). No corresponding blueprint lemma block.

---

## Blueprint adequacy for this file

- **Coverage**: ~85 Lean declarations have a corresponding `\lean{...}` block. The 4 new helpers listed above are unreferenced. Of these, 3 are substantive project-local lemmas directly consumed by `genericFlatness` (not tiny one-liners); 1 is a supporting transport lemma.
- **Proof-sketch depth**: **under-specified** for `thm:generic_flatness` STEP 3. The blueprint's proof (lines 2418–2480) describes the overall strategy but does not give the semilinearity argument needed to close `flatV`:
  - Blueprint says: "transport `Γ(F, D(g)) = Γ(F, D(ḡ))`" — but does not specify that this requires calling `flat_of_ringEquiv_semilinear` with `RingEquiv.refl` and the presheaf map iso.
  - Blueprint does not mention that semilinearity reduces to a `Scheme.Modules.map_smul` + `map_appLE`/`appLE_map` commutative square calculation.
  - The Lean file's own comment (lines 3563–3584) is more detailed than the blueprint sketch.
  - All other proof blocks (algebraic dévissage, G1, G3 assembly) are adequately sketched.
- **Hint precision**: **precise** — every `\lean{...}` pin in the chapter names the correct Lean declaration; no wrong-predicate or ambiguous-name issues found.
- **Generality**: **matches need** — blueprint declarations are at the right level of generality. The 4 missing helpers are project-specific infrastructure that the blueprint would ideally reference.
- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Add a `\begin{lemma}...\end{lemma}` block for `flat_of_ringEquiv_semilinear` (under "Geometric bridges", §B1.x) — the flatness analogue of `lem:module_free_of_ringEquiv`, pinning `AlgebraicGeometry.flat_of_ringEquiv_semilinear`.
  2. Add a `\begin{lemma}...\end{lemma}` block for `flat_localization_models` (under §B1, beside or after `lem:gf_flat_localizedModule_sameBase`) — "Flatness of a localization is independent of the chosen model", pinning `AlgebraicGeometry.flat_localization_models`.
  3. Add a `\begin{lemma}...\end{lemma}` block for `gf_flat_isLocalizedModule_sameBase` as B1′ — "Localizing the source preserves base-ring flatness (model-free form)", pinning `AlgebraicGeometry.gf_flat_isLocalizedModule_sameBase`. Can be merged with or noted as a corollary of `lem:gf_flat_localizedModule_sameBase`.
  4. Add a `\begin{lemma}...\end{lemma}` block for `isLocalizedModule_powers_restrictScalars` (under "Transport helpers") — "Descent of a localized-module structure along a scalar tower (base submonoid)", pinning `AlgebraicGeometry.isLocalizedModule_powers_restrictScalars`.
  5. Expand the `thm:generic_flatness` proof sketch to include the STEP-3 semilinearity argument: "The presheaf isomorphism `Γ(F, D(ḡ')) ≅ Γ(F, D(g))` along `hbg` is `Γ(S, D(f))`-semilinear (using `Scheme.Modules.map_smul` and the `map_appLE`/`appLE_map` algebra), so `flat_of_ringEquiv_semilinear` with `RingEquiv.refl` transports flatness."
  6. Remove or update the stale "(sorry this iter)" annotation from `thm:generic_flatness_algebraic`'s Lean module docstring (prover-side fix).

---

## Severity summary

| Finding | Severity |
|---|---|
| 4 new helpers (`gf_flat_isLocalizedModule_sameBase`, `flat_of_ringEquiv_semilinear`, `flat_localization_models`, `isLocalizedModule_powers_restrictScalars`) have no `\lean{}` pin in the blueprint | **major** |
| `genericFlatness` `flatV` STEP-3 `sorry` (line 3585): blueprint proof sketch does not specify the semilinearity argument; prover had to derive the recipe independently | **major** |
| Stale "(sorry this iter)" comment in `genericFlatnessAlgebraic` module doc (line 1957): claim is false — the proof body is sorry-free | **major** |
| Blueprint NOTE at `lem:gf_base_localization_comparison` (line 2082) acknowledges Lean proves weaker form (`Module.Flat`) vs prose (`IsLocalization`); no planner fix applied yet | **minor** (already noted in blueprint) |

**Overall verdict**: The Lean file is in good shape — all blueprint-pinned declarations exist with correct signatures and the dévissage is axiom-clean — but the blueprint has 3 major gaps: 4 unregistered substantive helpers, an under-specified STEP-3 sketch for the remaining `sorry`, and a stale "(sorry this iter)" annotation in a now-complete proof.
