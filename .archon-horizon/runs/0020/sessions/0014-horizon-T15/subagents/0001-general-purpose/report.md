You are building a NEW Lean 4 (Mathlib v4.31) file in the project at `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge` (this is your CWD; run `lake` and the Lean LSP MCP here). This is milestone **B1** of the Picard-scheme representability campaign. Your deliverable is a reusable "sheaf-level H⁰ base change" brick and its automorphism-freeness consumer.

## MATHEMATICAL GOAL
For a proper geometrically integral curve `C` over a field `k` (`C : Over (Spec (CommRingCat.of k))` with `[IsProper C.hom] [GeometricallyIntegral C.hom]`), and an ARBITRARY scheme `T` over `Spec k` (`πT : T ⟶ Spec (CommRingCat.of k)`), let `π := pullback.snd C.hom πT : (C ×_k T) ⟶ T` (the second projection of `Limits.pullback C.hom πT`). The structure-sheaf pushforward comparison map `𝒪_T ⟶ π_* 𝒪_{C×T}` is an **isomorphism** — equivalently, for every open `V ⊆ T`, the ring map `π.app (op V) : Γ(T, V) → Γ(C×T, π⁻¹V)` is bijective; in particular `Γ(T,⊤) → Γ(C×T,⊤)` is bijective. Intuition: a global function on `C×T` is pulled back from `T` (because `Γ(C_κ,𝒪)=κ` on every fibre — the field-of-constants fact — and this commutes with base change). The key downstream consequence (lm:aut): a UNIT on `C×T` that restricts to `1` along a section `σ : T → C×T` of `π` must be `1`.

## SUBSTRATE YOU MUST REUSE (verified sorry-free/axiom-clean this session — do NOT reprove)
File `AlgebraicJacobian/Picard/SectionRingUniversal.lean` (campaign B0), namespace `AlgebraicGeometry.Scheme`, `variable {k : Type u} [Field k]`, has `open`-scoped instance `globalSectionsAlgebra`:
- `globalSectionsAlgEquivBase (C) [IsProper C.hom] [GeometricallyIntegral C.hom] : Γ(C.left, ⊤) ≃ₐ[k] k`  (UNCONDITIONAL; `Γ(C,𝒪)=k`).
- `globalSectionsBaseChangeAlgEquiv {X : Scheme.{u}} (iX : X ⟶ Spec (CommRingCat.of k)) [CompactSpace X] [QuasiSeparatedSpace X] (A : Type u) [CommRing A] [Algebra k A]` : a `Γ(Spec A,⊤)`-algebra iso `Γ(Spec A,⊤) ⊗_{Γ(Spec k,⊤)} Γ(X,⊤) ≃ₐ Γ(X ×_k Spec A, ⊤)` (the tensor's non-canonical Algebra instances are supplied by `letI` in its return type — read the exact statement at lines ~194-227). Its `commutes'` proves `includeLeftRingHom ≫ e₀.hom = (pullback.snd iX (Spec.map (ofHom (algebraMap k A)))).app ⊤`.
- `constMap C = (ΓSpecIso (of k)).inv ≫ C.hom.appTop`; `surjective_constMap` / `HasTrivialConstants` unconditional.
READ THIS FILE FIRST in full to get exact signatures.

Conventions elsewhere: `LineBundle.OnProduct πC πT` (`Picard/LineBundlePullback.lean:130`) = `{M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M}`. The relative Pic product is `Limits.pullback C.hom T.hom`. A proper morphism gives `CompactSpace`/`QuasiSeparatedSpace`/`IsProper (pullback.snd ...)` by instance (base change of proper).

## KEY MATHLIB / IN-TREE TOOLS (confirmed present)
- Structure-sheaf map of a scheme morphism `f : X ⟶ Y`: `f.app (op U) : Γ(Y,U) → Γ(X, f⁻¹ᵁ U)`, and the underlying sheaf nat-trans `f.c : Y.presheaf ⟶ f.base _* X.presheaf` (`f.app U = f.c.app (op U)` up to defeq; check the exact API via LSP hover). `IsIso (f.app U)` from stalk isos: `TopCat.Presheaf.app_isIso_of_stalkFunctor_map_iso` (`Topology/Sheaves/Stalks.lean:640`); whole-map version `isIso_of_stalkFunctor_map_iso` (:658); `stalkFunctor_map_injective_of_isBasis` (:492), `exists_mem_germ_eq_of_isBasis` (:475).
- Affine opens are a basis: `AlgebraicGeometry.Scheme.isBasis_affineOpens (T) : Opens.IsBasis T.affineOpens`.
- **TEMPLATE**: `AlgebraicJacobian/Picard/QuotScheme.lean:868` `isIso_sheaf_of_isIso_app_basicOpen` shows the exact "iso on a basis ⟹ iso of sheaves via stalks" pattern (for Spec R / sheaves of modules). Adapt it to a GENERAL scheme `T` with the affine-opens basis and sheaves of CommRings (the structure sheaf).
- `MorphismProperty.isomorphisms`, `IsStableUnderBaseChange`, `pullback` pasting lemmas (`pullbackSymmetry`, `Limits.pullback.map`, open-immersion pullback) — for identifying `π⁻¹V ≅ C ×_k V`.

## PROOF ROUTE for the arbitrary-T iso (the crux)
1. Per-affine-open iso: for `V ⊆ T` an affine open (so `V.toScheme ≅ Spec Γ(V,⊤)`), the preimage `π ⁻¹ᵁ V` is `C ×_k V` (base change of `C.hom` along `V.ι ≫ πT`), and the restricted comparison `Γ(T,V) → Γ(C×T, π⁻¹V)` is exactly the B0 base-change iso `globalSectionsBaseChangeAlgEquiv` at `A = Γ(V,⊤)` (composed with `includeLeftRingHom`, which is bijective because `Γ(C,𝒪) ≅ Γ(Spec k,𝒪)` via `globalSectionsAlgEquivBase` collapses the right tensor factor — `Algebra.TensorProduct.rid`/`congr` after transporting `Γ(C)≅base`). Conclude `IsIso (π.app (op V))` for affine `V`.
2. Stalk isos everywhere: mimic `isIso_sheaf_of_isIso_app_basicOpen` with `T.isBasis_affineOpens` in place of `PrimeSpectrum.isBasis_basic_opens`.
3. `IsIso (π.app (op ⊤))` via `app_isIso_of_stalkFunctor_map_iso` (or `IsIso π.c` via `isIso_of_stalkFunctor_map_iso`).

Note: if the full base-change identification of `π⁻¹V` fights you badly, an acceptable simpler primary target is the AFFINE-BASE case `T = Spec A` proved directly from B0 (see priority order), plus the general case behind a gate.

## DELIVERABLES, IN STRICT PRIORITY ORDER (land each axiom-clean before moving on)
Create `AlgebraicJacobian/Picard/StructureSheafPushforward.lean`. Start `import Mathlib` + `import AlgebraicJacobian.Picard.SectionRingUniversal` (+ `LineBundlePullback` if needed for lm:aut). `set_option autoImplicit false`. `universe u`. `open CategoryTheory Limits AlgebraicGeometry`. Namespace `AlgebraicGeometry.Scheme`.

**P1 (MUST LAND — direct B0 corollary):** For `A : Type u` `[CommRing A] [Algebra k A]`, with `g := Spec.map (CommRingCat.ofHom (algebraMap k A))` and `π := pullback.snd C.hom g`, the ring hom `(π.appTop).hom : Γ(Spec A,⊤) → Γ(C ×_k Spec A, ⊤)` is **bijective** (`Function.Bijective` and/or `IsIso (π.appTop)`). Proof: `globalSectionsBaseChangeAlgEquiv C.hom A` gives the iso onto `Γ(pullback)`; `commutes'` identifies `π.appTop` with `includeLeft ≫ e`; `includeLeftRingHom` is bijective since `Γ(C.left,⊤) ≃ₐ[k] k ≅ Γ(Spec k,⊤)` makes the right tensor factor the base (`globalSectionsAlgEquivBase` + `ΓSpecIso`). Name it e.g. `bijective_snd_appTop_of_isAffine` / `isIso_snd_appTop_baseChange`.

**P2 (HIGH VALUE — the real brick):** For arbitrary `T` and `πT : T ⟶ Spec (of k)`, `π := pullback.snd C.hom πT`: `IsIso (π.app (op V))` for every affine open `V`, and hence `IsIso (π.app (op (⊤ : T.Opens)))` and (best) `IsIso π.c`. Follow the route above. If it does not fully close, land the affine-open per-`V` iso and/or gate the stalk-assembly step behind a `Prop`-class (house pattern, e.g. `class HasStructureSheafPushforwardIso ... where iso : ...`) and prove the consumers modulo it.

**P3 (CONSUMER — lm:aut):** From P2, for arbitrary `T` with a section `σ : T ⟶ C×T` of `π` (i.e. `σ ≫ π = 𝟙 T`), any global section `u : Γ(C×T, ⊤)` with `σ.app _ u = π.app _ (1)`-shaped rigidification collapses: prove the clean statement that `Γ(T,⊤) → Γ(C×T,⊤)` bijective + `σ` a section ⟹ a `u` with `σ.appTop u = (π.appTop) 1` (or `σ⁻¹`-pullback `= 1`) equals `π.appTop 1`. State it as the reusable "global functions on `C×T` are pulled back from `T`, uniquely" lemma. Getting the exact unit/automorphism phrasing perfect is secondary — the ring-level "section splits the iso ⟹ determined by restriction" lemma is the goal.

## HARD REQUIREMENTS
- **NO sorry/admit/native_decide in anything you claim closed.** If you cannot close a step, either (a) prove a weaker honest statement, or (b) put it behind a `Prop`-class gate with NO sorried instance and prove downstream modulo it — and say so explicitly. Never pin a false-general statement.
- After each declaration compiles, verify axiom-cleanliness with the LSP `lean_verify` (expect `[propext, Classical.choice, Quot.sound]`, no `sorryAx`).
- At the end run `lake build AlgebraicJacobian.Picard.StructureSheafPushforward` (or `lake env lean` on the file) in the FOREGROUND and confirm exit 0. Report the exact command + result.
- Match house style (snake_case props, `Is`-prefix, meaningful names). Add real docstrings citing campaign B1 / Kleiman §2.
- Use the Lean LSP MCP (`lean_goal`, `lean_multi_attempt`, `lean_hover_info`, `lean_diagnostic_messages`) for tight feedback; only kernel-build at the end.

## REPORT BACK (concise)
- Exact list of declarations landed, each with its axiom footprint (`lean_verify` result).
- Which priority items closed fully vs. gated vs. not attempted, with the gate class name if any.
- The final `lake build` command and its exit status (MUST be run and reported — this is a one-shot session, I cannot re-run it for you).
- Any false-statement traps you found, and any friction points (defeq/universe walls) with file:line.
Do NOT edit any file other than the new `StructureSheafPushforward.lean` (and do not touch `SectionRingUniversal.lean`).
