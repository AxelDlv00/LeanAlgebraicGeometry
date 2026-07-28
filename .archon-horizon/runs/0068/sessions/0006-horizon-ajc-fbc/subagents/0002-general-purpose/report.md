## MOST SERIOUS FINDING FIRST

**CLAIM 3's "same isomorphism" wording is false, and the CLAIM 3/4 reduction chain has an unstated missing step.**

### 1. "builds the *same* isomorphism" — REFUTED as written (docs defect, not a proof defect)

`.../CechHigherDirectImageUnconditional.lean:1878-1879` and `:2443` say `cech_pushforward_baseChange_natIso_of_isIso` "builds the **same** isomorphism" / "the *same* isomorphism". It does not. The `NatIso.ofComponents` version's components are `pushPull_sigma_iso` + per-σ `pushPullObj_coverInter_baseChange` + `PreservesProduct.iso` (file:2500-2512); the whiskered version's components are the mate `cechOuterBC`'s components. Proving them equal *is* the residue the session itself names two paragraphs later ("an isomorphism between two objects is not `IsIso` of a given map"). So the file contradicts itself on the same page. Same wording in the roadmap: `AJC.fbc.cosimplicial.pushforward` — "builds the SAME cosimplicial isomorphism".

**But the downstream conclusion survives.** I substituted the whiskered form into the assembly (`/tmp/rev_probe14.lean`, exit 0):
```
'RevCheck14.cosimpIso_via_whisker' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
```
It typechecks in `cechComplex_baseChange_cosimplicialIso`'s slot, and nothing downstream (`alternatingCofaceMapComplex.mapIso` → `homologyMapIso` → `Nonempty (… ≅ …)`) consumes any component-level fact. So "replace the declaration" is sound; only the word "same" is wrong. Correct wording: *an isomorphism with the same endpoints, obtained without the naturality obligation.*

### 2. `isIso_app_pi_of_isIso_app` does NOT land on `natIso_of_isIso`'s hypothesis — OVER-STATED

Module header `:85`, `:2446`, and both roadmap items state that `isIso_app_pi_of_isIso_app` "reduces the whole residue to one `IsIso` per index tuple σ". Measured: it does not, directly. The nerve's degree-`n` object is *not* the σ-product:
```
/tmp/rev_probe13.lean:11: error: Type mismatch ... rfl
  (drop.obj (CechNerve 𝒰 F)).obj n = ∏ᶜ fun σ => pushPullObj F (Over.mk (ι (coverInterOpen 𝒰 σ)))
```
and the direct feed fails (`/tmp/rev_probe4.lean:45`):
```
has type      IsIso (α.app (∏ᶜ fun j => pushPullObj F (Over.mk (ι (coverInterOpen 𝒰 j)))))
but expected  IsIso (α.app ((drop.obj (CechNerve 𝒰 F)).obj n))
```
A transport of `IsIso (α.app ·)` along `pushPull_sigma_iso` is needed and **no such lemma exists** in the project or (under the names I searched) in mathlib. It is cheap — 5 lines — and I closed the chain end-to-end (`/tmp/rev_probe8.lean`, exit 0, per-σ `IsIso` ⟹ `∀ n, IsIso (cechOuterBC.app ((drop.obj (CechNerve 𝒰 F)).obj n))`). So: the reduction is *real and complete*, but it is a three-lemma chain, not two, and the missing link is unlanded. The session's own note "the degree-`n` object of the dropped nerve IS `pushPullObj F (backbone n)` by `rfl`" is true (verified) but does not bridge to the product.

`isIso_app_pi_of_isIso_app`'s instance hypotheses **are** satisfiable at the intended `P = pushforward f ⋙ pullback g`, `Q = pullback g' ⋙ pushforward f'`, `J = Fin (p+1) → 𝒰.I₀` — all five synthesised (`/tmp/rev_probe5.lean` case D2, no error at that example). Not a vacuous reduction.

---

## CLAIM 1 — CONFIRMED, and the `[X.IsSeparated]` caveat is weaker than the session says

- Conclusions of `cech_flatBaseChange` (`:2694`) and `cech_flatBaseChange_qcoh` (`:2786`) are **literally character-identical** after whitespace normalisation (only the `:= by` vs `:=` token differs).
- Hypothesis delta is exactly `[X.IsSeparated]` (plus a cosmetic name `h𝒰` on an existing binder). Nothing else.
- `[X.IsSeparated]` is **redundant**, not merely mild: it is derivable from `[IsSeparated f]` alone (no affineness) in three lines — `terminal.comp_from f` + `IsSeparated.comp_iff` (`/tmp/rev_probe6.lean`, exit 0). I built `cech_flatBaseChange`'s conclusion from `cech_flatBaseChange`'s *exact* hypothesis list by routing through `_qcoh` (`/tmp/rev_probe4.lean` case B, no error). So `_qcoh` excludes nothing. Caveat: plain `infer_instance` does **not** find it (`/tmp/rev_probe2.lean:10` synth failure), so it is 3 lines, not free.
- Flat-exactness leaf absent from the proof term: `#print axioms` cannot show this directly (both endpoints report `sorryAx` from the naturality leaves). Decisive substitute — the whole `_qcoh` route with the cosimplicial iso `e` as a hypothesis (`/tmp/rev_probe12.lean`):
```
'RevCheck12.qcohRoute_modulo_e' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Clean. So `pullback_preservesMonomorphisms` is genuinely unreachable through the homology half. `pullback_mapHC_homologyIso_of_isQuasicoherent` is also clean.
- Minor inconsistency: module header `:44-45` advertises `_qcoh` as "no extra hypotheses" without mentioning `[X.IsSeparated]`, while the theorem's own docstring `:2772` does mention it. Same omission in `AJC.fbc` and `AJC.fbc.exactness` summaries.

## CLAIM 2 — CONFIRMED

All four sorry-free and axiom-clean (`/tmp/rev_probe.lean`): `isQuasicoherent_cechComplex_X`, `isQuasicoherent_pushforward_specMap`, `isQuasicoherent_pushforward_of_isAffine`, `isQuasicoherent_pi_of_isAffine`, `isQuasicoherent_pi_of_isAffineBase` — all `[propext, Classical.choice, Quot.sound]`. Statements match their names.

**The h3 index question: no defect, and the underscore is already gone.** Commit `89d00ba84` ("WRITE THE DEGREE INDEX OF h3 EXPLICITLY") — *not* in your list of session commits but an ancestor of HEAD and part of this run — replaced the `_` with `((ComplexShape.up ℕ).next i)`, and that is the correct index. Verified by `rfl` (`/tmp/rev_probe6.lean`, exit 0):
- `((CechComplex f 𝒰 F).sc i).X₂ = (CechComplex f 𝒰 F).X i` — rfl ✓
- `((CechComplex f 𝒰 F).sc i).X₃ = (CechComplex f 𝒰 F).X ((ComplexShape.up ℕ).next i)` — rfl ✓
- `X₃ = X (i+1)` is *not* rfl (needs `simp`), so the explicit `next i` form is the right spelling.

`{J : Type}` → `{J : Type u}`: confirmed changed at `79a30f40d` (`{J : Type}`) vs HEAD `:518` (`{J : Type u}`). Sole caller is in-file (`:544`, `:645`). No external callers anywhere in the workspace, so nothing broke. Pedantic note: this is a universe *change*, not a generalisation (`Type u` does not subsume `Type 0` for `u ≠ 0`) — harmless only because the caller set is empty.

## CLAIM 3 — statements CONFIRMED, "same isomorphism" REFUTED (see finding 1), reduction OVER-STATED (finding 2)

`cech_pushforward_baseChange_natIso_of_isIso` (`:1882`) has no naturality hypothesis and is axiom-clean. Its statement, normalised, is **byte-identical** on both sides to `cech_pushforward_baseChange_natIso` (`:2468`) — verified by string comparison of both conclusions. `cechOuterBC` is clean.

## CLAIM 4 — CONFIRMED, re-derived independently

I did not trust the session's two `rfl`s; I wrote my own (`/tmp/rev_probe6.lean` and `/tmp/rev_probe9.lean`):
- S-level leaf, **both** sides `rfl`-equal to `drop.obj (CechNerve 𝒰 F) ⋙ (composite)` — both directions pass (probe6 exit 0).
- Twisted leaf: LHS `= N ⋙ pullback g'` passes; RHS as a whiskering of `N` **fails**:
```
/tmp/rev_probe9.lean:31: error: Type mismatch ... rfl
  drop.obj (CechNerve 𝒰' ((pullback g').obj F)) = drop.obj (CechNerve 𝒰 F) ⋙ pullback g'
```
Agreed on all counts: there is no natural transformation to whisker for the twisted leaf, and the "two-nerve comparison" characterisation of its residue is right. The reversal of priority in `e40c4ff34` was a correct self-correction.

## Build, sorries, tree state

- `lake build AlgebraicJacobian.Cohomology.CechHigherDirectImageUnconditional` → **exit 0, "Build completed successfully (2896 jobs)"**.
- Exactly **3** sorries, at `:852` (`pullback_preservesMonomorphisms`), `:2468` (`cech_pushforward_baseChange_natIso`), `:2551` (`twisted_cech_nerve_iso`). The grep-for-"sorry" hits elsewhere are all docstring prose.
- Working tree file is md5-identical to ledger HEAD (`e675938157e607c873e986f32f08cd28`, 2807 lines) — nothing uncommitted in the file under review.
- `5b5331d7e` ("FLAT BASE CHANGE WITH NO SIDE HYPOTHESES") is a **record-only commit with an empty diff** — its content was swept into `dade15772` by another lane. The commit message says so; I confirmed the diff is empty and that the declarations are present at `dade15772`.

## Scratch files at the project root

Present now (absolute paths under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/`):
`Probe3.lean`, `Probe4.lean`, `GroundProbe.lean`, `GroundProbe2.lean`…`GroundProbe6.lean`, `probe_deg.lean`, `probe_pd.lean`, `probe_root.lean`, `scratch_pd.lean`.

**None of these belong to the session under review** — they import `Picard/Pic0AbelianVariety`, `Albanese/*`, `RiemannRoch/WeilDivisor`; none imports the Čech module. They are other live lanes' (`ajc-pic0av`, `ajc-albanese`, `ajc-rr`). The fbc session's own probes (`Probe5.lean`…`Probe10.lean`, mtimes 20:06–21:42 matching its commit times) **existed when I started and were removed during my review** — so this session did clean up after itself. Note `.gitignore:26` covers `*Probe*.lean` but the lowercase `probe_deg.lean`, `probe_pd.lean`, `probe_root.lean` are **not** ignored (verified with `check-ignore`).

## Recommended corrections (docs only)

1. Replace "the *same* isomorphism" with "an isomorphism with the same endpoints, built without the naturality obligation" at `:1878`, `:2443`, and in the `AJC.fbc.cosimplicial.pushforward` / `AJC.fbc` summaries.
2. State the missing third link: per-σ `IsIso` → degreewise `IsIso` needs a transport of `IsIso (α.app ·)` along `pushPull_sigma_iso`, which is unlanded (5 lines; I have a working proof). Amend `:85`, `:2446` and both roadmap summaries.
3. Either mention `[X.IsSeparated]` in the module-header bullet `:44-45` and in the `AJC.fbc*` summaries, or note that it is derivable from `[IsSeparated f]` in three lines and drop it from the signature.
