You are extending an EXISTING Lean 4 (Mathlib v4.31) file to close a gate. CWD = `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge` (run `lake` and the Lean LSP MCP here). Edit ONLY `AlgebraicJacobian/Picard/StructureSheafPushforward.lean` (read it fully first). Do NOT touch any other file.

## CURRENT STATE (already axiom-clean, kernel-green)
The file (namespace `AlgebraicGeometry.Scheme`, `variable {k : Type u} [Field k]`) has:
- `bijective_snd_appTop_baseChange C A` : `Function.Bijective ((pullback.snd C.hom (Spec.map (ofHom (algebraMap k A)))).appTop).hom`.
- `bijective_snd_appTop_of_isAffine (C) [IsProper C.hom] [GeometricallyIntegral C.hom] {W : Scheme.{u}} [IsAffine W] (h : W ⟶ Spec (of k)) : Function.Bijective ((pullback.snd C.hom h).appTop).hom`  ← **works for ANY affine base W and ANY structure map h. This is your per-affine-open ingredient.**
- `class HasStructureSheafPushforwardIso (C) {T : Scheme.{u}} (πT : T ⟶ Spec (of k)) : Prop where isIso_appTop : IsIso ((pullback.snd C.hom πT).appTop)` — the gate.
- `instHasStructureSheafPushforwardIso_of_isAffine` : discharges the gate for affine T only.
- P3 lm:aut consumers (leave untouched).

## GOAL — close the gate UNCONDITIONALLY for ARBITRARY T
Prove, for a proper geometrically integral curve `C/k` and ANY `T : Scheme.{u}` with `πT : T ⟶ Spec (of k)`, that `IsIso ((pullback.snd C.hom πT).appTop)` — then replace `instHasStructureSheafPushforwardIso_of_isAffine` with (or add) an UNCONDITIONAL instance `instHasStructureSheafPushforwardIso (C) [IsProper C.hom] [GeometricallyIntegral C.hom] {T} (πT) : HasStructureSheafPushforwardIso C πT`. (Keep the affine instance too if convenient, or subsume it.) The math: degree-0 cohomology-and-base-change / Kleiman §2 — `Γ(T,V) → Γ(C×T, π⁻¹V)` is the base-change iso on every affine open V, and these assemble to a sheaf iso.

## EXACT ROUTE (all lemma names verified present in Mathlib v4.31)
Let `π := pullback.snd C.hom πT`.

### Step A — per-affine-open iso: `IsIso (π.app (op V))` for every affine open `V : T.Opens` with `hV : IsAffineOpen V`.
1. `IsAffine V.toScheme` from `hV` (`IsAffineOpen.isAffine_toScheme` / `hV`).
2. `bijective_snd_appTop_of_isAffine C (V.ι ≫ πT)` gives `Bijective ((pullback.snd C.hom (V.ι ≫ πT)).appTop).hom`  [affine base W := V.toScheme].
3. Arrow iso `morphismRestrictOpensRange π V.ι : Arrow.mk (π ∣_ V.ι.opensRange) ≅ Arrow.mk (pullback.snd π V.ι)` (`AlgebraicGeometry/Restrict.lean:674`). Note `V.ι.opensRange = V` (`Scheme.Opens.opensRange_ι`).
4. Pasting: `pullbackLeftPullbackSndIso C.hom πT V.ι : pullback (pullback.snd C.hom πT) V.ι ≅ pullback C.hom (V.ι ≫ πT)` (dual of `pullbackRightPullbackFstIso`, `CategoryTheory/Limits/Shapes/Pullback/Pasting.lean`), compatible with `snd` (check the `_hom_snd`/`_hom_fst` simp lemmas; verify the exact argument order via LSP hover). So `pullback.snd π V.ι` is iso-arrow to `pullback.snd C.hom (V.ι ≫ πT)`.
5. Chain the arrow/scheme isos to transfer `appTop` bijectivity from `pullback.snd C.hom (V.ι ≫ πT)` (step 2) to `(π ∣_ V).appTop`. Use the SAME arrow-transport pattern already in `bijective_snd_appTop_of_isAffine` (congrArg `Scheme.Hom.appTop` on a commuting square of scheme isos, then `IsIso` composition; `isIso_appTop_of_isIso` for iso maps).
6. `morphismRestrict_app'` / `morphismRestrict_appTop` (`Restrict.lean:637/643`): `(π ∣_ V).appTop = π.app (V.ι ''ᵁ ⊤) ≫ (iso)`, and relate `π.app (op V)` to `(π ∣_ V).appTop` (note `V.ι ''ᵁ ⊤ = V` up to the standard image lemma; there may be an `eqToHom`/`op` bookkeeping — use `morphismRestrict_app'` which gives `f.appLE`). Conclude `IsIso (π.app (op V))`. If the `V.ι ''ᵁ ⊤ = V` bookkeeping is painful, instead directly prove `IsIso ((π ∣_ V).appTop)` and use THAT as the per-basis-open datum in Step B (adjust the stalk lemma to speak about `π ∣_ V` restrictions if cleaner).

### Step B — stalk assembly: from Step A to `IsIso (π.appTop)`.
Mirror the project template `AlgebraicGeometry.Scheme.isIso_sheaf_of_isIso_app_basicOpen` at `AlgebraicJacobian/Picard/QuotScheme.lean:868` (READ IT — it is the exact "iso on a basis ⟹ iso of the sheaf map via stalks" pattern), but:
- Use the affine-opens basis `T.isBasis_affineOpens : Opens.IsBasis T.affineOpens` (`AlgebraicGeometry/AffineScheme.lean:303`) instead of `PrimeSpectrum.isBasis_basic_opens`.
- Work with the structure-sheaf comparison sheaf map `α := π.c` (the `PresheafedSpace`/`LocallyRingedSpace` sheaf-hom `T.presheaf ⟶ π.base _* (C×T).presheaf`; `π.app (op V) = α.app (op V)` up to the standard defeq — verify with LSP). Both `T.presheaf` and `π.base _* (C×T).presheaf` are SHEAVES (pushforward of a sheaf is a sheaf), so package as `TopCat.Sheaf CommRingCat _`.
- Stalk lemmas: `TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis` (`Topology/Sheaves/Stalks.lean:492`), `exists_mem_germ_eq_of_isBasis` (:475), `isIso_of_stalkFunctor_map_iso` (:658), and to extract the `⊤` component `app_isIso_of_stalkFunctor_map_iso` (:640). Injectivity/surjectivity of stalk maps come from Step A's per-affine-open bijectivity exactly as in the template.
- Conclude `IsIso (π.app (op ⊤)) = IsIso (π.appTop)`.

## FALLBACK / HONESTY
If Step B's sheaf/stalk packaging proves too costly to close cleanly this session, that is acceptable: (1) LAND Step A (`isIso_snd_app_of_isAffineOpen`, per-affine-open iso) as a standalone axiom-clean lemma — it is genuine reusable progress; (2) leave the gate `HasStructureSheafPushforwardIso` in place with its affine instance; (3) report precisely where Step B stuck (the exact goal state and the missing lemma). NEVER introduce a `sorry`/`admit`/`native_decide` or a sorried instance. NEVER weaken the gate to a false-general instance.

## HARD REQUIREMENTS
- Everything you claim closed must be `sorry`-free and `lean_verify`-axiom-clean (`[propext, Classical.choice, Quot.sound]`, no `sorryAx`). Verify each new decl with `lean_verify`.
- At the end run `lake build AlgebraicJacobian.Picard.StructureSheafPushforward` in the FOREGROUND; report the exact command + exit status (this is one-shot; I cannot re-run it).
- Use the Lean LSP MCP (`lean_goal`, `lean_multi_attempt`, `lean_hover_info`) for tight feedback. `set_option maxHeartbeats 400000 in` per-declaration if needed. `set_option backward.isDefEq.respectTransparency false in` where defeq walls appear (the file already uses it).

## REPORT (concise)
- Whether the gate closed unconditionally (the new instance name) OR only Step A landed (with the exact stuck point in Step B).
- Each new decl + its `lean_verify` axiom footprint.
- The final `lake build` command + exit status (MUST run + report).
- Any friction (file:line, missing lemma, defeq/universe wall).
