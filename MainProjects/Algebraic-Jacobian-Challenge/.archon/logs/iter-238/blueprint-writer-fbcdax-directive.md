# blueprint-writer fbcdax directive

## Chapter to edit
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (ONLY this chapter).

## Why (context)
The lemma `lem:pushforward_spec_tilde_iso` (`\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}`,
~L260–360) is the engine brick. The iter-237 prover built the WHOLE route-iii skeleton axiom-clean
but reduced the unconditional iso to ONE named obligation it could not close after 3 iters of hitting
the same wall (the progress-critic ruled the lane STUCK). The chapter's proof sketch is mathematically
correct but does NOT spell out HOW to formalize that last obligation — so the prover keeps
re-discovering the wall. Your job is to expand the proof with the precise, element-free recipe (which
is already proven to work at the `⊤` level in this same chapter), so the next prover round can
instantiate it directly.

## The named obligation (`hloc`)
For `N := (Spec φ)_* (tilde M)` and each `a : R`, one must show the structure-sheaf restriction map
of `N` over the basic open `D(a)` is `IsLocalizedModule (Submonoid.powers a)`. The difficulty: the
`R`-action on the pushforward sections over `D(a)` is built through the GLOBAL ring (via
`modulesSpecToSheaf`), so the naive identity `a •_R x = φ(a) •_{R'} x` does not synthesize at the
section level. This is the SAME "structure-sheaf smul carrier wall" that was already resolved
element-free at the `⊤` level by `lem:gammaPushforwardIso` (`\lean{AlgebraicGeometry.gammaPushforwardIso}`,
~L203) — using `ModuleCat.restrictScalarsComp'App` (×2) + an `eqToIso` built from a `⊤`-level ring
equation (`globalSectionsIso_hom_comp_specMap_appTop`).

## What to ADD to the proof of `lem:pushforward_spec_tilde_iso`
Expand the `\emph{The computation over $D(a)$.}` paragraph (~L324–340) into an explicit element-free
construction mirroring `lem:gammaPushforwardIso`, with these movements (math prose, NO Lean tactics):

1. **The `D(a)`-level linear equivalence `e_{D(a)}`.** Construct, in exact analogy to the `⊤`-level
   `gammaPushforwardIso`, an `R`-linear isomorphism
   \[
     e_{D(a)} : \Gamma\bigl((\operatorname{Spec}\varphi)_*\widetilde M,\, D(a)\bigr)
       \;\cong\; \operatorname{restr}_\varphi\bigl(\Gamma(\widetilde M,\, D(\varphi a))\bigr)
   \]
   via the same two `restrictScalarsComp'App` reconciliations and an `eqToIso`, but where the
   `eqToIso` now rests on a **`D(a)`-level ring equation** instead of the `⊤`-level one.

2. **The `D(a)`-level ring equation.** State it explicitly: the `Γ(Spec R, ⊤)`-action on the
   pushforward sections over `D(a)` factors through `(Spec φ).app (D(a))` after restriction, i.e.
   \[
     (\operatorname{Spec}\varphi).\mathrm{app}(D(a)) \circ \mathrm{res}_{\top \to D(a)} \circ g_R
       \;=\; \mathrm{res}_{\top \to D(\varphi a)} \circ g_{R'} \circ \varphi,
   \]
   where `g_R : R → Γ(Spec R, ⊤)`, `g_{R'} : R' → Γ(Spec R', ⊤)` are the global-section ring maps.
   Note `(Spec φ)^{-1} D(a) = D(φ a)` (which is definitional). This is the sheaf-naturality of the
   structure-sheaf comparison of `Spec.map φ` at `D(a)`, the `D(a)`-shadow of the `⊤`-level
   `globalSectionsIso_hom_comp_specMap_appTop`.

3. **Discharging `hloc` via transport.** The target `Γ(tilde M, D(φa)) = M[1/φa]` is
   `IsLocalizedModule (powers (φ a))` over `R'` (Mathlib's tilde-localization instance). Transport
   this through `e_{D(a)}` and through the restriction-of-scalars converse
   `IsLocalizedModule.powers_restrictScalars` (the ring-change core, see below) to obtain the
   `IsLocalizedModule (powers a)` instance over `R` on the source — i.e. exactly `hloc`. Cite
   `IsLocalizedModule.of_linearEquiv` (transport along a linear equivalence) as the transport
   mechanism. Feeding `hloc` to the already-built conditional form
   `pushforward_spec_tilde_iso_of_isLocalizedModule` yields the unconditional iso.

Keep the existing high-level "two localizations agree" prose, but make the above the explicit
formalization route so the prover does not re-derive the wall. Mark plainly that the element-free
`⊤`-level template is `lem:gammaPushforwardIso` and the new `D(a)` construction is its specialization
(localization map `R → R[1/a]` in place of the global ring map).

## Also ADD: `\lean{}` helper blocks (the 3 iter-237 decls now lack pins)
Add three short lemma/definition blocks (Archon-original infrastructure — no external SOURCE needed,
they are project-bespoke Lean glue) with `\lean{}` pins and correct `\uses{}`:

- `\lemma` `\label{lem:powers_restrictScalars}`
  `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` — the converse of Mathlib's
  `IsLocalizedModule.of_restrictScalars`: for an `R`-algebra `A`, `S : Submonoid R`, and
  `f : M →ₗ[A] N` with `[IsLocalizedModule (Algebra.algebraMapSubmonoid A S) f]`, the `R`-linear
  `f.restrictScalars R` is `IsLocalizedModule S` (using
  `Algebra.algebraMapSubmonoid R' (powers a) = powers (φ a)`). The ring-change core of movement 3.
- `\lemma` `\label{lem:fromTildeGamma_app_isIso_of_localized}`
  `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` — the section-level engine: for
  `N : (Spec R).Modules`, if the structure-sheaf restriction of `N` to `D(a)` is
  `IsLocalizedModule (powers a)`, then `N.fromTildeΓ.app (basicOpen a)` is an isomorphism. `\uses` the
  Mathlib tilde-localization. (This is the per-basic-open input to `lem:modules_isIso_of_isBasis`.)
- `\lemma` `\label{lem:pushforward_spec_tilde_iso_conditional}`
  `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` — the route-iii assembly
  taking `hloc` (the per-`D(a)` localization fact) as an explicit hypothesis and producing the iso via
  `lem:modules_isIso_of_isBasis` + `lem:gammaPushforwardTildeIso`. `\uses{lem:modules_isIso_of_isBasis,
  lem:gammaPushforwardTildeIso, lem:fromTildeGamma_app_isIso_of_localized}`.

Repoint the main `lem:pushforward_spec_tilde_iso` proof `\uses` to additionally reference
`lem:pushforward_spec_tilde_iso_conditional` and `lem:powers_restrictScalars`. Update or remove the
stale `% NOTE:` at L260–268 to reflect that the helper blocks now exist (the dangling-pin note for the
unconditional `pushforward_spec_tilde_iso` itself stays until the prover closes it).

## Out of scope
- Do NOT touch any other chapter.
- Do NOT add `\leanok` / `\mathlibok` markers (managed by sync / review).
- Do NOT alter the `% SOURCE QUOTE` blocks (byte-intact).
- The deep `thm:flat_base_change_pushforward` (Čech+flatness, L504) stays as-is.

You MAY dispatch a reference-retriever if you find you need a source not in `references/`, but this
expansion is project-bespoke Lean glue + an internal element-free recipe — no new external source
should be needed.
