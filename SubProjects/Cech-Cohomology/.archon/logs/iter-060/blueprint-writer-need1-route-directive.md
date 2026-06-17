# Blueprint-writer directive — realign hjt/hqc to the VERIFIED transport route

## Target chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter).

## Source of truth (READ FIRST)
`analogies/need1-transport.md` — a mathlib-analogist recipe written THIS iter. It contains a
**compiled, axiom-clean** proof of `hjt` and a construction-level skeleton + ranked sub-facts (R1/R2/R3)
for `hqc`. The current blueprint blocks for both lemmas describe SUPERSEDED routes; your job is to
replace them with the verified route. Do not invent content beyond the analogy file + the Mathlib API it
names.

## Strategy context (the slice that matters)
`Φ = Scheme.Modules.pushforwardEquivOfIso φ : U.Modules ≌ (Spec R).Modules` for `φ : U ≅ Spec R`. Two
transport facts discharge the open-immersion acyclicity leaf:
- `hjt : Φ.functor.obj (jShriekOU V) ≅ jShriekOU (φ.inv ⁻¹ᵁ V)` (`lem:jshriek_transport_along_iso`).
- `hqc : (Φ.functor.obj H).IsQuasicoherent` for qcoh `H` (`lem:pushforward_iso_preserves_qcoh`).

## Task 1 — rewrite `lem:jshriek_transport_along_iso` (hjt) to the corepresentability route

The OLD proof (lines ~9550–9584) "unfolds `jShriekOU = sheafify∘free∘yoneda` and chases three
commutations" through `lem:pushforward_commutes_free`, `lem:pushforward_commutes_sheafify`,
`lem:yoneda_transport_along_homeo`. **That route is abandoned.** The verified route (analogy file §hjt,
~12 lines, axiom-clean) is a CorepRESENTABILITY transport:

- `coyoneda(op (Φ.functor.obj A)) ≅ Φ.inverse ⋙ coyoneda(op A)` via the Mathlib equivalence–coyoneda
  iso `Adjunction.compCoyonedaIso` (applied to `Φ.toAdjunction`).
- `coyoneda(op A) ≅ sectionsFunctor V ⋙ forget` via the project's already-built `sectionsFunctorCorepIso`
  (whiskered by `forget AddCommGrpCat`); rests on `preadditiveCoyoneda.obj X ⋙ forget = coyoneda.obj X`
  being `rfl`.
- the relabel `Φ.inverse ⋙ sectionsFunctor V = sectionsFunctor (φ.inv ⁻¹ᵁ V)` is `rfl` ("sections of a
  pushforward are the sections over the preimage open").
- compose into `coyoneda(op (Φ.functor.obj A)) ≅ coyoneda(op (jShriekOU (φ.inv⁻¹V)))`, then reflect via
  `Coyoneda.fullyFaithful.preimageIso` (`.symm.unop`).

Rewrite the proof prose to this chain (textbook level, project notation — NO Lean tactic strings; you may
name the Mathlib lemmas inline as references). Update the statement and proof `\uses{}` to:
`\uses{def:jshriek_ou, lem:sectionsFunctorCorepIso, lem:compCoyonedaIso_mathlib, lem:coyoneda_fullyFaithful_mathlib}`
(drop the three obsolete lemmas). **Remove the "deep adjunction-mate / chase three commutations"
framing.** Keep the `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}` pin and the
`% NOTE: build target...` comment (the Lean decl still does not exist — the prover builds it this iter).

**Add three small anchor/helper blocks** (place them just above the hjt lemma):
- `\label{lem:compCoyonedaIso_mathlib}` `\lean{CategoryTheory.Adjunction.compCoyonedaIso}` `\mathlibok` —
  "for an adjunction `F ⊣ G`, `coyoneda(op (F.obj A)) ≅ G ⋙ coyoneda(op A)`." Mathlib anchor.
- `\label{lem:coyoneda_fullyFaithful_mathlib}` `\lean{CategoryTheory.Coyoneda.fullyFaithful}` `\mathlibok`
  — "`coyoneda` is fully faithful, hence reflects isomorphisms." Mathlib anchor.
- `\label{lem:sectionsFunctorCorepIso}` `\lean{AlgebraicGeometry.sectionsFunctorCorepIso}` — the project's
  corepresentability iso `sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))` (already built in
  `OpenImmersionPushforward.lean`). One-line informal proof + `\uses{def:jshriek_ou}`.

## Task 2 — DELETE the three obsolete sub-lemma blocks

The route change orphans them (used ONLY by hjt — verified: their only `\uses`/`\ref` references are in
the hjt block you are rewriting). Delete the full `\begin{lemma}…\end{lemma}` (+ any `\begin{proof}`) for:
- `lem:pushforward_commutes_free` (`\lean{AlgebraicGeometry.pushforward_commutes_free}`, ~line 9472–9499)
- `lem:pushforward_commutes_sheafify` (`\lean{AlgebraicGeometry.pushforward_commutes_sheafify}`, ~9501–9518)
- `lem:yoneda_transport_along_homeo` (`\lean{AlgebraicGeometry.yoneda_transport_along_homeo}`, ~9520–9548)

After deletion, grep the WHOLE chapter for those three labels and remove any lingering `\uses{}`/`\ref{}`
mentions so `leandag build` reports `unknown_uses: []` and no isolated nodes.

## Task 3 — rewrite `lem:pushforward_iso_preserves_qcoh` (hqc) to the `of_coversTop`/R1 route

The OLD proof (lines ~9610–9653) does a vague "by-hand presentation transport across the homeomorphism."
Replace it with the verified skeleton (analogy file §hqc). The Lean route is a `QuasicoherentData`
transport, structurally a copy of `SheafOfModules.QuasicoherentData.bind`'s `presentation` field:

1. Extract `H`'s local datum `q` (cover `q.X : q.I → Opens X` of `⊤`, with `q.presentation i :
   (H.over (q.X i)).Presentation`) via `IsQuasicoherent.nonempty_quasicoherentData`.
2. Apply `IsQuasicoherent.of_coversTop` with the IMAGE cover `fun i => φ.inv ⁻¹ᵁ (q.X i)` (covers `⊤` by
   transporting `q.coversTop` along the homeomorphism `φ.inv.base` — sub-fact **R3**, cheap).
3. Each per-`i` piece is qcoh by transporting `q.presentation i` across the over-site equivalence
   `eᵢ : (X.Modules ⇂ q.X i) ≌ (Y.Modules ⇂ φ.inv⁻¹ q.X i)` built from
   `SheafOfModules.pushforwardPushforwardEquivalence` (already anchored at
   `lem:pushforwardPushforwardEquivalence_mathlib`), using `Presentation.map eᵢ.functor ηᵢ` (sub-fact
   **R2** `ηᵢ : eᵢ.functor.obj unit ≅ unit`, routine) then `Presentation.ofIsIso` along the comparison
   iso. The single non-trivial input is **R1**: the comparison iso
   `eᵢ.functor.obj (H.over Vᵢ) ≅ (Φ_*H).over (φ.inv⁻¹Vᵢ)` ("pushforward commutes with restriction to an
   open"), ~40–100 LOC.

Add a dedicated sub-lemma block for **R1** (the genuinely new content) and structure hqc to `\uses` it:
- `\label{lem:pushforward_commutes_restriction}` (R1) — statement: for the over-site equivalence `eᵢ`
  induced by `φ` restricted to the open, `eᵢ.functor.obj (H.over V) ≅ (Φ.functor.obj H).over (φ.inv⁻¹V)`.
  `\uses{lem:pushforwardPushforwardEquivalence_mathlib, lem:restrict_obj_mathlib}` (+ whatever the
  analogy file's R1 paragraph names). Informal proof = the analogy file's R1 description (adapt the `bind`
  `presentation`-field construction, homeomorphism-induced opens-site equivalence in place of
  `Over.iteratedSliceEquiv`).
- Update `lem:pushforward_iso_preserves_qcoh`'s statement+proof `\uses{}` to:
  `lem:pushforward_commutes_restriction, lem:pushforwardPushforwardEquivalence_mathlib,
  lem:presentation_map_mathlib, lem:isQuasicoherent_of_coversTop_mathlib,
  lem:presentation_ofIsIso_mathlib, lem:isAffineOpen_image_of_iso_mathlib` (add Mathlib anchors below for
  any not already present — `\mathlibok`, `\lean{}` at the real Mathlib name:
  `SheafOfModules.IsQuasicoherent.of_coversTop`, `SheafOfModules.Presentation.ofIsIso`,
  `SheafOfModules.IsQuasicoherent.nonempty_quasicoherentData`). Keep the existing
  `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source}` Stacks block — it remains accurate.

If the prover will likely factor hqc through a generic engine `isQuasicoherent_pushforwardEquivOfIso`
(generic `φ : X ≅ Y`), you MAY add that as a separate lemma block that `lem:pushforward_iso_preserves_qcoh`
instantiates — your judgement; keep the `\lean{}` pin on the consumer
`AlgebraicGeometry.pushforward_iso_preserves_qcoh` regardless.

## Constraints
- NO `\leanok` (sync_leanok owns it). `\mathlibok` ONLY on genuine Mathlib anchors (the named Mathlib
  decls). Do NOT mark the project's own to-be-proved lemmas.
- Keep the chapter LaTeX-balanced; verify with `leandag build --json` (`unknown_uses: []`, 0 isolated).
- Cite verbatim from `references/` ONLY for content you actually read locally; the existing hqc Stacks
  quote is fine to keep. You may need `references/**` for nothing new here — the route is project/Mathlib
  infra, not a new external theorem.

## Out of scope
- Do NOT touch the Route-A (CSI / `lem:cech_backbone_left_sigma`, distributivity) blocks — they are
  correct as of writer-iter060.
- Do NOT add `\leanok` anywhere.
